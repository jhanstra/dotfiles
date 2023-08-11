source $HOME/.dotfileconfig
export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
export EDITOR='vscode'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
ZSH_DISABLE_COMPFIX=true
# Set up PATH
export BUN_INSTALL="$HOME/.bun"
CORE="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
HOMEBREW="/opt/homebrew/bin:/opt/homebrew/sbin"
DOTFILES_BIN="$DOTFILES/bin"
DENO="$HOME/.deno/bin"
MYSQL="/usr/local/mysql/bin"
POSTGRES="/Applications/Postgres.app/Contents/Versions/12/bin"
VSCODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
BUN="$BUN_INSTALL/bin"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$CORE:$DOTFILES_BIN:$HOMEBREW:$ZSH:$DENO:$MYSQL:$POSTGRES:$PNPM_HOME:$VSCODE:$BUN"
export VERCEL_TOKEN=$(grep VERCEL_TOKEN ~/personal/dotfiles/.env | cut -d '=' -f2)
export VERCEL_ORG_ID=$(grep VERCEL_ORG_ID ~/personal/dotfiles/.env | cut -d '=' -f2)

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

eval "$(fasd --init auto)" # Set up fasd
unalias d
source $DOTFILES/config/aliases.zsh # Add aliases
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # nvm completions
# [ -s "/Users/jth/.bun/_bun" ] && source "/Users/jth/.bun/_bun" # bun completions