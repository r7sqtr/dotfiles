#!/usr/bin/env bash
# 依存関係のライセンス情報をTSV形式で抽出するスクリプト
# パッケージマネージャを自動検出し、対応するツールでライセンスを取得
# 出力: パッケージ名\tバージョン\tライセンス\tリスクレベル
set -uo pipefail

PROJECT_DIR="${1:-.}"
cd "${PROJECT_DIR}" || { echo "ERROR: ディレクトリに移動できません: ${PROJECT_DIR}" >&2; exit 1; }

# リスクレベル判定
classify_risk() {
  local license="$1"
  case "${license}" in
    AGPL*|SSPL*)
      echo "CRITICAL"
      ;;
    GPL-2.0*|GPL-3.0*|GPL*)
      echo "HIGH"
      ;;
    LGPL*|MPL*|EPL*|EUPL*|OSL*|CPAL*)
      echo "MEDIUM"
      ;;
    MIT|ISC|BSD-2-Clause|BSD-3-Clause|Apache-2.0|Unlicense|CC0-1.0|0BSD|BlueOak-1.0.0|Zlib)
      echo "LOW"
      ;;
    UNLICENSED|""|UNKNOWN|"(license not found)")
      echo "CRITICAL"
      ;;
    *)
      echo "MEDIUM"
      ;;
  esac
}

# ヘッダー出力
echo -e "パッケージ\tバージョン\tライセンス\tリスクレベル"
echo -e "---\t---\t---\t---"

FOUND_PM=false

# --- npm / Node.js ---
if [[ -f "package.json" ]]; then
  FOUND_PM=true
  if command -v npm &>/dev/null && [[ -d "node_modules" ]]; then
    # npm ls でライセンス取得を試行
    npm ls --all --json 2>/dev/null | jq -r '
      .dependencies // {} | to_entries[] |
      "\(.key)\t\(.value.version // "?")\t\(.value.license // .value.licenses // "UNKNOWN")"
    ' 2>/dev/null | while IFS=$'\t' read -r name version license; do
      # license がオブジェクトや配列の場合の正規化
      license=$(echo "${license}" | sed 's/^\[//;s/\]$//;s/^{.*"type":"\([^"]*\)".*/\1/;s/"//g')
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  else
    # フォールバック: node_modules の package.json から直接抽出
    if [[ -d "node_modules" ]]; then
      find node_modules -maxdepth 2 -name "package.json" -not -path "*/node_modules/*/node_modules/*" 2>/dev/null | while read -r pkg_json; do
        info=$(jq -r '[.name // "unknown", .version // "?", (.license // .licenses // "UNKNOWN") | if type == "object" then .type // "UNKNOWN" elif type == "array" then map(if type == "object" then .type else . end) | join(", ") else . end] | @tsv' "${pkg_json}" 2>/dev/null) || continue
        name=$(echo "${info}" | cut -f1)
        version=$(echo "${info}" | cut -f2)
        license=$(echo "${info}" | cut -f3)
        risk=$(classify_risk "${license}")
        echo -e "${name}\t${version}\t${license}\t${risk}"
      done
    else
      echo -e "(npm: node_modules未検出。npm install を実行してください)\t-\t-\t-" >&2
    fi
  fi
fi

# --- Go ---
if [[ -f "go.mod" ]]; then
  FOUND_PM=true
  if command -v go &>/dev/null; then
    go list -m -json all 2>/dev/null | jq -r 'select(.Dir) | "\(.Path)\t\(.Version // "?")\t\(.Dir)"' 2>/dev/null | while IFS=$'\t' read -r name version dir; do
      # LICENSE ファイルからライセンス種別を推定
      license="UNKNOWN"
      license_file=$(find "${dir}" -maxdepth 1 -iname "license*" -o -iname "copying*" 2>/dev/null | head -1)
      if [[ -n "${license_file}" ]]; then
        content=$(head -20 "${license_file}" 2>/dev/null || true)
        if echo "${content}" | grep -qi "MIT License"; then license="MIT"
        elif echo "${content}" | grep -qi "Apache License.*2\.0"; then license="Apache-2.0"
        elif echo "${content}" | grep -qi "BSD 3-Clause"; then license="BSD-3-Clause"
        elif echo "${content}" | grep -qi "BSD 2-Clause"; then license="BSD-2-Clause"
        elif echo "${content}" | grep -qi "GNU GENERAL PUBLIC LICENSE.*Version 3"; then license="GPL-3.0"
        elif echo "${content}" | grep -qi "GNU GENERAL PUBLIC LICENSE.*Version 2"; then license="GPL-2.0"
        elif echo "${content}" | grep -qi "GNU LESSER GENERAL PUBLIC LICENSE"; then license="LGPL"
        elif echo "${content}" | grep -qi "Mozilla Public License.*2\.0"; then license="MPL-2.0"
        elif echo "${content}" | grep -qi "ISC License"; then license="ISC"
        fi
      fi
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  fi
fi

# --- Cargo / Rust ---
if [[ -f "Cargo.toml" ]]; then
  FOUND_PM=true
  if command -v cargo &>/dev/null; then
    cargo metadata --format-version 1 --no-deps 2>/dev/null | jq -r '
      .packages[] |
      "\(.name)\t\(.version)\t\(.license // "UNKNOWN")"
    ' 2>/dev/null | while IFS=$'\t' read -r name version license; do
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
    # 依存関係も取得
    cargo metadata --format-version 1 2>/dev/null | jq -r '
      .packages[] | select(.source != null) |
      "\(.name)\t\(.version)\t\(.license // "UNKNOWN")"
    ' 2>/dev/null | while IFS=$'\t' read -r name version license; do
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  fi
fi

# --- pip / Python ---
if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
  FOUND_PM=true
  if command -v pip &>/dev/null; then
    pip list --format=json 2>/dev/null | jq -r '.[] | "\(.name)\t\(.version)"' 2>/dev/null | while IFS=$'\t' read -r name version; do
      license=$(pip show "${name}" 2>/dev/null | grep -i "^License:" | sed 's/^License: *//' || echo "UNKNOWN")
      [[ -z "${license}" ]] && license="UNKNOWN"
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  fi
fi

# --- Composer / PHP ---
if [[ -f "composer.json" ]]; then
  FOUND_PM=true
  if command -v composer &>/dev/null; then
    composer licenses --format=json 2>/dev/null | jq -r '
      .dependencies // {} | to_entries[] |
      "\(.key)\t\(.value.version // "?")\t\(.value.license // ["UNKNOWN"] | join(", "))"
    ' 2>/dev/null | while IFS=$'\t' read -r name version license; do
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  fi
fi

# --- Bundler / Ruby ---
if [[ -f "Gemfile" ]]; then
  FOUND_PM=true
  if command -v bundle &>/dev/null; then
    bundle list 2>/dev/null | grep "^\s*\*" | sed 's/^\s*\* //' | while read -r gem_info; do
      name=$(echo "${gem_info}" | sed 's/ (.*//')
      version=$(echo "${gem_info}" | sed 's/.*(\(.*\))/\1/')
      license=$(gem specification "${name}" license 2>/dev/null | grep -v "^---" | sed 's/^- //' | head -1 || echo "UNKNOWN")
      [[ -z "${license}" ]] && license="UNKNOWN"
      risk=$(classify_risk "${license}")
      echo -e "${name}\t${version}\t${license}\t${risk}"
    done
  fi
fi

if [[ "${FOUND_PM}" == "false" ]]; then
  echo "WARNING: サポートされているパッケージマネージャが検出されませんでした。" >&2
  echo "対応: package.json, go.mod, Cargo.toml, requirements.txt, pyproject.toml, composer.json, Gemfile" >&2
  exit 1
fi
