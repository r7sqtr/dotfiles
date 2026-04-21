# 関数定義

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
