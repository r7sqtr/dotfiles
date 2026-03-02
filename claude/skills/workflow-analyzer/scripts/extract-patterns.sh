#!/usr/bin/env bash
# セッションログからワークフローパターンを抽出するスクリプト
# 使用方法: extract-patterns.sh [セッション数(デフォルト: 20)]
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
echo "=== ワークフローパターン抽出 ==="
echo "対象: 直近 ${FILE_COUNT} セッション"
echo ""

# 全ファイルからツール名を一括抽出（高速化）
ALL_TOOLS="${TMPDIR_WORK}/all_tools.txt"
ALL_USER_MSGS="${TMPDIR_WORK}/all_user_msgs.txt"
: > "${ALL_TOOLS}"
: > "${ALL_USER_MSGS}"

for file in "${SESSION_FILES[@]}"; do
  jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | .name // empty
  ' "${file}" 2>/dev/null >> "${ALL_TOOLS}" || true

  jq -r '
    select(.type == "user")
    | .message.content
    | if type == "string" then .
      elif type == "array" then map(select(.type == "text") | .text) | join(" ")
      else empty
    end
  ' "${file}" 2>/dev/null >> "${ALL_USER_MSGS}" || true
done

# --- 1. ツール呼び出しシーケンス（セッション毎） ---
echo "## ツール呼び出しシーケンス"
echo ""

for file in "${SESSION_FILES[@]}"; do
  project=$(basename "$(dirname "${file}")")
  session_id=$(basename "${file}" .jsonl)

  tools=$(jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | .name // empty
  ' "${file}" 2>/dev/null | paste -sd "→" - || true)

  if [[ -n "${tools}" ]]; then
    echo "### ${project} (${session_id:0:8})"
    echo "${tools}"
    echo ""
  fi
done

# --- 2. ツール使用頻度 ---
echo "## ツール使用頻度（全セッション合計）"
echo ""
sort "${ALL_TOOLS}" | uniq -c | sort -rn | head -30
echo ""

# --- 3. ツールペア（連続する2つのツール呼び出し） ---
echo "## 頻出ツールペア（連続する2ツール）"
echo ""

prev=""
while IFS= read -r line; do
  if [[ -n "${prev}" && -n "${line}" ]]; then
    echo "${prev} → ${line}"
  fi
  prev="${line}"
done < "${ALL_TOOLS}" | sort | uniq -c | sort -rn | head -20
echo ""

# --- 4. ユーザーメッセージのキーワード頻度 ---
echo "## ユーザーメッセージ（頻出ワード）"
echo ""
tr '[:space:]' '\n' < "${ALL_USER_MSGS}" | grep -E '.{2,}' | sort | uniq -c | sort -rn | head -40 || true
echo ""

# --- 5. プロジェクト別セッション数 ---
echo "## プロジェクト別セッション数"
echo ""
for file in "${SESSION_FILES[@]}"; do
  basename "$(dirname "${file}")"
done | sort | uniq -c | sort -rn
echo ""

# --- 6. セッション統計 ---
echo "## セッション統計"
echo ""

total_user=0
total_assistant=0
total_tool=0

for file in "${SESSION_FILES[@]}"; do
  user_msgs=$(jq -c 'select(.type == "user")' "${file}" 2>/dev/null | wc -l | tr -d ' ')
  assistant_msgs=$(jq -c 'select(.type == "assistant")' "${file}" 2>/dev/null | wc -l | tr -d ' ')
  tool_calls=$(jq -c 'select(.type == "assistant") | .message.content[]? | select(.type == "tool_use")' "${file}" 2>/dev/null | wc -l | tr -d ' ')
  total_user=$((total_user + user_msgs))
  total_assistant=$((total_assistant + assistant_msgs))
  total_tool=$((total_tool + tool_calls))
done

echo "ユーザーメッセージ合計: ${total_user}"
echo "アシスタントメッセージ合計: ${total_assistant}"
echo "ツール呼び出し合計: ${total_tool}"
if [[ ${FILE_COUNT} -gt 0 ]]; then
  echo "平均ツール呼び出し/セッション: $((total_tool / FILE_COUNT))"
fi
