# macOS Terminal.app のセッション復元を無効化（WezTerm使用のため不要）
export SHELL_SESSIONS_DISABLE=1

. "$HOME/.cargo/env"

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
