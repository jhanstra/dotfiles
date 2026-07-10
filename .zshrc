# source our custom .dotfileconfig set up at the start of the mac
source $HOME/.dotfileconfig

export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
export EDITOR='vscode'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
ZSH_DISABLE_COMPFIX=true


# Set up PATH
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
CORE="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
HOMEBREW="/opt/homebrew/bin:/opt/homebrew/sbin"
DOTFILES_BIN="$DOTFILES/bin"
DENO="$HOME/.deno/bin"
MYSQL="/usr/local/mysql/bin"
POSTGRES="/Applications/Postgres.app/Contents/Versions/12/bin"
VSCODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
BUN="$BUN_INSTALL/bin"
# RUBY="/opt/homebrew/opt/ruby/bin:/usr/local/lib/ruby/gems/3.3.0/bin"

export PATH="$CORE:$DOTFILES_BIN:$HOMEBREW:$ZSH:$DENO:$MYSQL:$POSTGRES:$PNPM_HOME:$VSCODE:$BUN"

# Load private environment variables from our dotfiles
if [[ -r "$DOTFILES/.env" ]]; then
  set -a
  source "$DOTFILES/.env"
  set +a
fi


export TZ="UTC"

# oh-my-zsh plugin list
plugins=(
  git
  colored-man-pages
  last-working-dir
  thefuck
  zsh-syntax-highlighting
)

ZSH_THEME="robbyrussell" # Set oh-my-zsh theme
# Other good themes: PowerLevel10k, Pure
unsetopt CORRECT # Turn off auto spell-correct
setopt AUTO_CD # Type the name of a folder to automatically cd into it
setopt NO_CASE_GLOB # Case-insensitive globbing
HISTFILE=~/.zsh_history # location of the history flile to save past commands
HISTSIZE=10000 # how many lines to keep in the history file
SAVEHIST=10000 # how many lines to remember in a single session
setopt EXTENDED_HISTORY # add timestamps and duration to history file
setopt SHARE_HISTORY # share history across multiple zsh sessions
setopt INC_APPEND_HISTORY # add commands to history as they're typed
setopt APPEND_HISTORY # append to history
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_FIND_NO_DUPS #ignore duplicates when searching
setopt HIST_REDUCE_BLANKS # removes blank lines from history
unsetopt BG_NICE # don't run background jobs at a lower priority

source $ZSH/oh-my-zsh.sh

# initialize autocomplete here, otherwise functions won't be loaded
# autoload -Uz compinit && compinit
# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#   autoload -Uz compinit
#   compinit
# fi

# eval "$(fasd --init auto)" # Set up fasd
eval "$(zoxide init zsh)"
source $DOTFILES/config/aliases.zsh # Add aliases
# Remove zoxide's 'd' alias if it exists, since we have our own 'd' alias
unalias d 2>/dev/null || true
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # nvm completions
# [ -s "/Users/jth/.bun/_bun" ] && source "/Users/jth/.bun/_bun" # bun completions

# Ruby / rbenv
# eval "$(rbenv init -)"
# . "$HOME/.local/bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jth/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jth/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jth/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jth/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.local/bin:$PATH"

# =============================
# Added via mac_setup.sh:

# Apple Silicon-friendly Node version manager
eval "$(fnm env --use-on-cd --version-file-strategy recursive)"

# This loads zsh completions for Brew packages
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

export PYCURL_SSL_LIBRARY=openssl
export LDFLAGS="-L$(brew --prefix)/opt/openssl/lib"
export CPPFLAGS="-I/$(brew --prefix)/opt/openssl/include"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

plugin=(
  pyenv
)

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# =============================
alias python=python3
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"

work() {
  if [[ "$1" == "sw" || "$1" == "switch" ]]; then
    local output
    output=$(command work "$@")
    if [[ -d "$output" ]]; then
      cd "$output"
    else
      echo "$output"
    fi
  else
    command work "$@"
  fi
}
export JIRA_USER_EMAIL="jared.hanstra@findheadway.com"
# Added by git-ai installer on Fri Mar  6 16:57:37 UTC 2026
export PATH="/Users/jhanstra/.git-ai/bin:$PATH"
