#!/bin/bash

input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
model_name=$(echo "$input" | jq -r '.model.display_name // ""')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Git branch
if [ -d "$current_dir/.git" ] || git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null || echo "")
else
    git_branch=""
fi

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
    if (( $(echo "$used_percentage < 50" | bc -l) )); then
        color="\033[32m"
    elif (( $(echo "$used_percentage < 80" | bc -l) )); then
        color="\033[33m"
    else
        color="\033[31m"
    fi
    components+=("$(printf "${color}ctx:%.1f%%\033[0m" "$used_percentage")")
fi

# Agent name (blue)
[ -n "$agent_name" ] && components+=("$(printf '\033[34m[%s]\033[0m' "$agent_name")")

# Output tokens (gray)
[ "$output_tokens" -gt 0 ] 2>/dev/null && components+=("$(printf '\033[90mout:%s\033[0m' "$output_tokens")")

# Join with separator
printf '%s' "${components[0]}"
for i in "${components[@]:1}"; do
    printf ' | %s' "$i"
done
