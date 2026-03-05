#!/bin/bash

input=$(cat)

# 1回のjq呼び出しで全フィールドを抽出
eval "$(echo "$input" | jq -r '
  @sh "current_dir=\(.workspace.current_dir // "")",
  @sh "model_name=\(.model.display_name // "")",
  @sh "used_percentage=\(.context_window.used_percentage // "")",
  @sh "agent_name=\(.agent.name // "")",
  @sh "output_tokens=\(.context_window.total_output_tokens // 0)"
' | tr ',' '\n')"

# Git branch（直接取得、存在確認不要）
git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null || echo "")

project_name=$(basename "$current_dir")

components=()

# Project name (cyan)
[ -n "$current_dir" ] && components+=("$(printf '\033[36m%s\033[0m' "$project_name")")

# Git branch (green)
[ -n "$git_branch" ] && components+=("$(printf '\033[32m⎇ %s\033[0m' "$git_branch")")

# Model name (magenta)
[ -n "$model_name" ] && components+=("$(printf '\033[35m%s\033[0m' "$model_name")")

# Context usage (green/yellow/red)
if [ -n "$used_percentage" ]; then
    used_int=$(printf '%.0f' "$used_percentage" 2>/dev/null || echo 0)
    if [ "$used_int" -lt 50 ]; then
        color="\033[32m"
    elif [ "$used_int" -lt 80 ]; then
        color="\033[33m"
    else
        color="\033[31m"
    fi
    components+=("$(printf "${color}ctx:%.1f%%\033[0m" "$used_percentage")")
fi

# Agent name (blue)
[ -n "$agent_name" ] && components+=("$(printf '\033[34m[%s]\033[0m' "$agent_name")")

# Output tokens (gray)
[ -n "$output_tokens" ] && [ "$output_tokens" -gt 0 ] 2>/dev/null && components+=("$(printf '\033[90mout:%s\033[0m' "$output_tokens")")

# 1行目: ステータスライン
printf '%s' "${components[0]}"
for i in "${components[@]:1}"; do
    printf ' | %s' "$i"
done

# --- Usage API レートリミット情報 ---

CACHE_FILE="/tmp/claude-usage-cache.json"
CACHE_TTL=360

# キャッシュの有効性を確認して読み込み
usage_json=""
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    [ "$cache_age" -lt "$CACHE_TTL" ] && usage_json=$(cat "$CACHE_FILE")
fi

# キャッシュが無効ならAPI呼び出し
if [ -z "$usage_json" ]; then
    cred_json=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    if [ -n "$cred_json" ]; then
        oauth_token=$(echo "$cred_json" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
        if [ -n "$oauth_token" ]; then
            usage_json=$(curl -s --max-time 5 \
                -H "Authorization: Bearer ${oauth_token}" \
                -H "anthropic-beta: oauth-2025-04-20" \
                -H "Content-Type: application/json" \
                "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
            if echo "$usage_json" | jq -e '.five_hour.utilization' > /dev/null 2>&1; then
                echo "$usage_json" > "$CACHE_FILE"
            else
                usage_json=""
            fi
        fi
    fi
fi

[ -z "$usage_json" ] && exit 0

# 色定義
COLOR_GREEN='\033[38;2;151;201;195m'
COLOR_YELLOW='\033[38;2;229;192;123m'
COLOR_RED='\033[38;2;224;108;117m'
COLOR_GRAY='\033[38;2;74;88;92m'
RESET='\033[0m'

# 使用率に応じた色を決定
get_usage_color() {
    local pct=$1
    if [ "$pct" -lt 50 ]; then echo "$COLOR_GREEN"
    elif [ "$pct" -lt 80 ]; then echo "$COLOR_YELLOW"
    else echo "$COLOR_RED"
    fi
}

# プログレスバー生成
make_progress_bar() {
    local pct=$1 color="$2"
    local filled=$(( pct / 10 )) empty=$(( 10 - pct / 10 ))
    local bar="" gray_part=""
    for ((i=0; i<filled; i++)); do bar+="▰"; done
    for ((i=0; i<empty; i++)); do gray_part+="▱"; done
    printf "${color}%s${COLOR_GRAY}%s${RESET}" "$bar" "$gray_part"
}

# UTC ISO 8601 → JST変換
format_reset_time() {
    local iso_time=$1 fmt=$2
    local epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "${iso_time%%.*}" "+%s" 2>/dev/null)
    [ -n "$epoch" ] && TZ=Asia/Tokyo date -j -r "$epoch" "+$fmt" 2>/dev/null || echo ""
}

# レートリミット行を表示
print_rate_limit_line() {
    local label=$1 pct=$2 color=$3 reset_fmt=$4
    printf '\n'
    printf "${COLOR_GRAY}%s ${RESET}[$(make_progress_bar "$pct" "$color")]" "$label"
    printf " ${color}%3d%%${RESET}" "$pct"
    [ -n "$reset_fmt" ] && printf " ${COLOR_GRAY}│${RESET} ${COLOR_GRAY}Reset: %s JST${RESET}" "$reset_fmt"
}

# 1回のjqで全usage値を抽出
eval "$(echo "$usage_json" | jq -r '
  @sh "five_hour_pct=\(.five_hour.utilization // 0 | round)",
  @sh "five_hour_reset=\(.five_hour.resets_at // "")",
  @sh "seven_day_pct=\(.seven_day.utilization // 0 | round)",
  @sh "seven_day_reset=\(.seven_day.resets_at // "")"
' | tr ',' '\n')"

print_rate_limit_line "⏱ 5h" "$five_hour_pct" "$(get_usage_color "$five_hour_pct")" "$(format_reset_time "$five_hour_reset" "%H:%M")"
print_rate_limit_line "📅 7d" "$seven_day_pct" "$(get_usage_color "$seven_day_pct")" "$(format_reset_time "$seven_day_reset" "%m/%d %H:%M")"
