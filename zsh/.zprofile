# Homebrew（キャッシュ付き）
_brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
_brew_bin="/opt/homebrew/bin/brew"
if [[ -x "$_brew_bin" ]]; then
  if [[ ! -f "$_brew_cache" ]] || [[ "$_brew_bin" -nt "$_brew_cache" ]]; then
    mkdir -p "${_brew_cache:h}"
    "$_brew_bin" shellenv > "$_brew_cache"
  fi
  source "$_brew_cache"
fi
unset _brew_cache _brew_bin

# ロケール
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad

# ユーザーのローカル bin
export PATH="$HOME/.local/bin:$PATH"

# pyenv（遅延読み込み）
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

_lazy_pyenv() {
  unfunction pyenv python python3 pip pip3 2>/dev/null
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  "$@"
}
for cmd in pyenv python python3 pip pip3; do
  eval "${cmd}() { _lazy_pyenv ${cmd} \"\$@\" }"
done

# nvm（遅延読み込み）
export NVM_DIR="$HOME/.nvm"

_lazy_nvm() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  "$@"
}
for cmd in nvm node npm npx; do
  eval "${cmd}() { _lazy_nvm ${cmd} \"\$@\" }"
done

# PHP
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
