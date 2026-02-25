# Starship
_starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship-init.zsh"
_starship_bin="$(whence -p starship 2>/dev/null)"
if [[ -n "$_starship_bin" ]]; then
  if [[ ! -f "$_starship_cache" ]] || [[ "$_starship_bin" -nt "$_starship_cache" ]]; then
    mkdir -p "${_starship_cache:h}"
    starship init zsh > "$_starship_cache"
  fi
  source "$_starship_cache"
fi
unset _starship_cache _starship_bin
