#!/usr/bin/env bash
# セッションログからユーザーの行動パターンを抽出するスクリプト
# 使用方法: extract-habits.sh [セッション数(デフォルト: 20)]
set -uo pipefail

CLAUDE_DIR="${HOME}/.claude"
PROJECTS_DIR="${CLAUDE_DIR}/projects"
MAX_SESSIONS="${1:-20}"
TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "${TMPDIR_WORK}"' EXIT

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq が必要です。brew install jq でインストールしてください。" >&2
  exit 1
fi

# セッションログファイルを更新日時の降順で取得
SESSION_LIST="${TMPDIR_WORK}/session_list.txt"
find "${PROJECTS_DIR}" -maxdepth 2 -name "*.jsonl" -type f 2>/dev/null \
  | xargs ls -t 2>/dev/null \
  | head -n "${MAX_SESSIONS}" > "${SESSION_LIST}"

SESSION_FILES=()
while IFS= read -r line; do
  SESSION_FILES+=("${line}")
done < "${SESSION_LIST}"

if [[ ${#SESSION_FILES[@]} -eq 0 ]]; then
  echo "ERROR: セッションログが見つかりません: ${PROJECTS_DIR}" >&2
  exit 1
fi

FILE_COUNT=${#SESSION_FILES[@]}
echo "=== ユーザー行動パターン抽出 ==="
echo "対象: 直近 ${FILE_COUNT} セッション"
echo ""

# 全セッションからユーザーメッセージとツール名を事前抽出
ALL_USER_MSGS="${TMPDIR_WORK}/all_user_msgs.txt"
ALL_TOOLS="${TMPDIR_WORK}/all_tools.txt"
: > "${ALL_USER_MSGS}"
: > "${ALL_TOOLS}"

for file in "${SESSION_FILES[@]}"; do
  jq -r '
    select(.type == "user")
    | .message.content
    | if type == "string" then .
      elif type == "array" then map(select(.type == "text") | .text) | join(" ")
      else empty
    end
  ' "${file}" 2>/dev/null >> "${ALL_USER_MSGS}" || true

  jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | .name // empty
  ' "${file}" 2>/dev/null >> "${ALL_TOOLS}" || true
done

# --- 1. 短いユーザー指示（コマンド的なもの） ---
echo "## 短いユーザー指示（50文字以下）"
echo ""

for file in "${SESSION_FILES[@]}"; do
  jq -r '
    select(.type == "user")
    | .message.content
    | if type == "string" then .
      elif type == "array" then map(select(.type == "text") | .text) | join(" ")
      else empty
    end
    | select(length > 0 and length <= 50)
  ' "${file}" 2>/dev/null || true
done | sort | uniq -c | sort -rn | head -30
echo ""

# --- 2. 頻出フレーズ（2-gram） ---
echo "## 頻出フレーズ（2-gram）"
echo ""

words_file="${TMPDIR_WORK}/words.txt"
tr '[:space:]' '\n' < "${ALL_USER_MSGS}" | grep -E '.{2,}' > "${words_file}" 2>/dev/null || true

prev=""
while IFS= read -r word; do
  if [[ -n "${prev}" ]]; then
    echo "${prev} ${word}"
  fi
  prev="${word}"
done < "${words_file}" | sort | uniq -c | sort -rn | head -30
echo ""

# --- 3. キーワード出現回数 ---
echo "## 繰り返し指示パターン（キーワード検出）"
echo ""

PATTERNS=(
  "日本語" "テスト" "コミット" "レビュー" "リファクタ"
  "修正" "追加" "削除" "確認" "説明"
  "型" "エラー" "デバッグ" "ドキュメント" "README"
  "PR" "issue" "ブランチ" "実装" "検索"
)

for pattern in "${PATTERNS[@]}"; do
  count=$(grep -c "${pattern}" "${ALL_USER_MSGS}" 2>/dev/null || true)
  count="${count:-0}"
  count=$(echo "${count}" | tr -d '[:space:]')
  if [[ -n "${count}" ]] && [[ "${count}" -gt 0 ]]; then
    printf "%6d  %s\n" "${count}" "${pattern}"
  fi
done | sort -rn
echo ""

# --- 4. プロジェクト別ツール使用パターン ---
echo "## プロジェクト別ツール使用パターン"
echo ""

for file in "${SESSION_FILES[@]}"; do
  project=$(basename "$(dirname "${file}")")
  jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | .name // empty
  ' "${file}" 2>/dev/null | while read -r tool; do
    echo "${project}	${tool}"
  done || true
done | sort | uniq -c | sort -rn | head -40
echo ""

# --- 5. セッション開始時の最初のユーザーメッセージ ---
echo "## セッション開始時の最初のユーザーメッセージ"
echo ""

for file in "${SESSION_FILES[@]}"; do
  project=$(basename "$(dirname "${file}")")
  first_msg=$(jq -r '
    select(.type == "user")
    | .message.content
    | if type == "string" then .
      elif type == "array" then map(select(.type == "text") | .text) | join(" ")
      else empty
    end
  ' "${file}" 2>/dev/null | head -1 || true)

  if [[ -n "${first_msg}" ]]; then
    if [[ ${#first_msg} -gt 80 ]]; then
      first_msg="${first_msg:0:80}..."
    fi
    echo "[${project}] ${first_msg}"
  fi
done
echo ""

# --- 6. Permission Mode 使用状況 ---
echo "## Permission Mode 使用状況"
echo ""

for file in "${SESSION_FILES[@]}"; do
  jq -r 'select(.type == "user") | .permissionMode // empty' "${file}" 2>/dev/null || true
done | sort | uniq -c | sort -rn
echo ""

# --- 7. 現在のルールファイル一覧 ---
echo "## 現在のルールファイル"
echo ""

rules_dir="${HOME}/.config/claude/rules"
if [[ -d "${rules_dir}" ]]; then
  for f in "${rules_dir}"/*.md; do
    if [[ -f "${f}" ]]; then
      name=$(basename "${f}")
      lines=$(wc -l < "${f}" | tr -d ' ')
      echo "- ${name} (${lines} 行)"
    fi
  done
else
  echo "(ルールディレクトリが存在しません)"
fi

claude_md="${HOME}/.claude/CLAUDE.md"
if [[ -f "${claude_md}" ]]; then
  lines=$(wc -l < "${claude_md}" | tr -d ' ')
  echo "- CLAUDE.md (${lines} 行)"
fi
