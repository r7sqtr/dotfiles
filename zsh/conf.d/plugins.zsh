# プラグイン遅延読み込み
autoload -U add-zsh-hook

_load_plugins() {
  [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  add-zsh-hook -d precmd _load_plugins
}
add-zsh-hook precmd _load_plugins

# プロンプト前の改行
_newline_before_prompt() {
  if [[ -z "$_NL_BEFORE_PROMPT" ]]; then
    _NL_BEFORE_PROMPT=1
  elif [[ "$_NL_BEFORE_PROMPT" -eq 1 ]]; then
    echo ""
  fi
}
add-zsh-hook precmd _newline_before_prompt
