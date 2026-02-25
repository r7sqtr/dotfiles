# conf.d/ の設定ファイルを読み込む
# 順序に依存関係あり: completion.zsh は env.zsh 後、aliases.zsh は functions.zsh 後
_zsh_confdir="${ZDOTDIR:-$HOME}/conf.d"

source "$_zsh_confdir/env.zsh"
source "$_zsh_confdir/secrets.zsh"
source "$_zsh_confdir/completion.zsh"
source "$_zsh_confdir/options.zsh"
source "$_zsh_confdir/prompt.zsh"
source "$_zsh_confdir/plugins.zsh"
source "$_zsh_confdir/functions.zsh"
source "$_zsh_confdir/aliases.zsh"

unset _zsh_confdir
