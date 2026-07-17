# .zshrc is the main configuration file for Zsh, the default shell for macOS

# source our custom .dotfileconfig set up at the start of the mac
[[ -r "$HOME/.dotfileconfig" ]] && source "$HOME/.dotfileconfig"

# Set up PATH. MacOS and Homebrew already manage core, man, homebrew paths, do not add here
typeset -U path PATH
path+=(
  "$HOME/.local/bin" # local bin
  "$HOME/.bun/bin" # globally installed Bun package binaries
  "$HOME/.antigravity-ide/antigravity-ide/bin" # antigravity ide
)

# Homebrew lives at /opt/homebrew on Apple Silicon Macs
BREW_DIR="/opt/homebrew"
path=(
  "$BREW_DIR/bin"
  "$BREW_DIR/sbin"
  # enable these if you need them
  # "$BREW_DIR/opt/mysql-client/bin" # mysql client binaries
  # "$BREW_DIR/opt/libpq/bin" # postgresql client binaries
  # "$BREW_DIR/share/google-cloud-sdk/bin" # optional gcloud components
  $path
)

# Enable mise-managed language versions through its directory-aware shims.
# This is equivalent to `mise activate zsh --shims` without spawning mise.
[[ -d "$HOME/.local/share/mise/shims" ]] &&
  path=("$HOME/.local/share/mise/shims" $path)

# Load private environment variables from our dotfiles .env
if [[ -z "${DOTFILES_ENV_LOADED:-}" && -r "$DOTFILES/.env" ]]; then
  set -a; source "$DOTFILES/.env"; set +a
  export DOTFILES_ENV_LOADED=1
fi

# General zsh settings
unsetopt CORRECT # Turn off auto spell-correct
unsetopt BANG_HIST # Treat exclamation points literally instead of expanding history
setopt AUTO_CD # Type the name of a folder to automatically cd into it
setopt NO_CASE_GLOB # Case-insensitive globbing
HISTFILE=~/.zsh_history # location of the history flile to save past commands
HISTSIZE=100000 # how many lines to keep in the history file
SAVEHIST=100000 # how many lines to remember in a single session
setopt EXTENDED_HISTORY # add timestamps and duration to history file
setopt SHARE_HISTORY # share history across multiple zsh sessions
setopt INC_APPEND_HISTORY # add commands to history as they're typed
setopt APPEND_HISTORY # append to history
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_IGNORE_SPACE # do not save commands that begin with a space
setopt HIST_FIND_NO_DUPS #ignore duplicates when searching
setopt HIST_REDUCE_BLANKS # removes blank lines from history
unsetopt BG_NICE # don't run background jobs at a lower priority

# Add zoxide for fast 'z' directory switching
if command -v zoxide >/dev/null 2>&1 &&
   (( ! $+functions[__zoxide_z] )); then
  eval "$(zoxide init zsh)"
fi

# Set other misc env variables
export EDITOR='cursor --wait'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export TZ="UTC"

# Register homebrew's completion functions before oh-my-zsh initializes compinit
typeset -U fpath FPATH
fpath=("$BREW_DIR/share/zsh/site-functions" $fpath)

# Load other configuration files
source "$DOTFILES/config/zsh/oh-my-zsh.zsh"
source "$DOTFILES/config/zsh/aliases.zsh"
source "$DOTFILES/config/zsh/functions.zsh"

# Replace zsh's reverse-history search with Atuin's contextual fuzzy search
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Load interactive plugins through Antidote. Syntax highlighting is listed last
# so it can wrap every existing line-editor widget.
ANTIDOTE_ROOT="$BREW_DIR/opt/antidote/share/antidote"
if [[ -r "$ANTIDOTE_ROOT/antidote.zsh" ]]; then
  ANTIDOTE_STATIC="${XDG_CACHE_HOME:-$HOME/.cache}/antidote/plugins.zsh"
  if [[ -r "$ANTIDOTE_STATIC" &&
        "$ANTIDOTE_STATIC" -nt "$DOTFILES/config/zsh/plugins.txt" ]]; then
    source "$ANTIDOTE_STATIC"
  else
    source "$ANTIDOTE_ROOT/antidote.zsh"
    mkdir -p "${ANTIDOTE_STATIC:h}"
    antidote load "$DOTFILES/config/zsh/plugins.txt" "$ANTIDOTE_STATIC"
  fi
  unset ANTIDOTE_STATIC
fi
unset ANTIDOTE_ROOT
unset BREW_DIR
