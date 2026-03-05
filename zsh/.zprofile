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

# PHP
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
