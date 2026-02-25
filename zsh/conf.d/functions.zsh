# 関数定義

# lsコマンド拡張
# Permission → 数字表記 ファイル容量 → B表記
lsinfo() {
  setopt localoptions nullglob
  files=(.* *)
  for f in $files; do
    [ -e "$f" ] || continue
    perms=$(stat -f "%Lp" "$f" 2>/dev/null)
    [ -z "$perms" ] && perms=$(stat -c "%a" "$f" 2>/dev/null)
    size=$(stat -f "%z" "$f" 2>/dev/null)
    [ -z "$size" ] && size=$(stat -c "%s" "$f" 2>/dev/null)
    if [ "$size" -lt 1024 ]; then
      size_display="${size}B"
    elif [ "$size" -lt $((1024 * 1024)) ]; then
      size_display="$((size / 1024))KB"
    else
      size_display="$((size / 1024 / 1024))MB"
    fi
    date=$(stat -f "%Sm" -t "%Y-%m-%d" "$f" 2>/dev/null)
    [ -z "$date" ] && date=$(stat -c "%y" "$f" 2>/dev/null | cut -d' ' -f1)
    if [ -d "$f" ]; then
      color="\e[34m"
    elif [ -x "$f" ]; then
      color="\e[32m"
    elif [[ "$f" == .* ]]; then
      color="\e[90m"
    else
      color="\e[0m"
    fi
    reset="\e[0m"
    printf "%-4s  %-6s  %-10s  ${color}%s${reset}\n" "$perms" "$size_display" "$date" "$f"
  done
}

# git worktree ヘルパー
wt() {
  if [[ "$1" == "cd" ]]; then
    shift
    local dir
    dir=$(git-wt _path "$@")
    [[ -n "$dir" ]] && cd "$dir"
  else
    git-wt "$@"
  fi
}

# Docker補完は必要なときだけ
docker_comp() {
  fpath=($HOME/.docker/completions $fpath)
  autoload -Uz compinit
  compinit
}
