# fpath 追加
[[ -d /usr/local/share/zsh-completions ]] && fpath=(/usr/local/share/zsh-completions $fpath)

# compinit
autoload -Uz compinit
# glob qualifier で 7日以上前かチェック
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -f ${_zcompdump}(#qNmh+168) ]] || [[ ! -f "$_zcompdump" ]]; then
  compinit -u -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# 補完スタイル
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''
