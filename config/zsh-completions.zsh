# Collect personal Zsh completion sources without initializing compinit twice.

# Register Homebrew's completion functions before Oh My Zsh initializes compinit.
typeset -U fpath FPATH
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
  unset HOMEBREW_PREFIX
fi

# Register Bun completions before compinit, or load them directly when a
# company-managed shell has already initialized the completion system.
if [[ -s "$HOME/.bun/_bun" ]]; then
  if (( $+functions[compdef] )); then
    source "$HOME/.bun/_bun"
  else
    fpath=("$HOME/.bun" $fpath)
  fi
fi
