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

# Add Homebrew paths
if (( $+commands[brew] )); then # check that brew is installed
  path+=(
    "$(brew --prefix)/opt/mysql-client/bin" # mysql client binaries
    "$(brew --prefix)/opt/libpq/bin" # postgresql client binaries
    "$(brew --prefix)/share/google-cloud-sdk/bin" # optional gcloud components
  )
fi

# Enable mise-managed language versions
if command -v mise >/dev/null 2>&1 && [[ -z "${MISE_SHELL:-}" ]]; then
  eval "$(mise activate zsh)"
fi

# Load private environment variables from our dotfiles .env
if [[ -r "$DOTFILES/.env" ]]; then
  set -a; source "$DOTFILES/.env"; set +a
fi

# General zsh settings
unsetopt CORRECT # Turn off auto spell-correct
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
setopt HIST_FIND_NO_DUPS #ignore duplicates when searching
setopt HIST_REDUCE_BLANKS # removes blank lines from history
unsetopt BG_NICE # don't run background jobs at a lower priority

# Add zoxide for fast 'z' directory switching
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Set other misc env variables
export EDITOR='cursor --wait'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export TZ="UTC"

# Register homebrew's completion functions before oh-my-zsh initializes compinit
typeset -U fpath FPATH
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
  unset HOMEBREW_PREFIX
fi

# Load other configuration files
source "$DOTFILES/config/zsh/oh-my-zsh.zsh"
source "$DOTFILES/config/zsh/aliases.zsh"
source "$DOTFILES/config/zsh/functions.zsh"
source "$DOTFILES/config/zsh/ai-functions.zsh"
