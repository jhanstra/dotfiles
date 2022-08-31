export PROJECTS=~/coprime
export DOTFILES="$PROJECTS/utils/dotfiles"
export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
export EDITOR='vscode'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# oh-my-zsh plugin list
plugins=(
  git
  colored-man-pages
  last-working-dir
  thefuck
  zsh-syntax-highlighting
)

# Set oh-my-zsh theme
ZSH_THEME="robbyrussell"

# cd ~/.oh-my-zsh/ && chmod 744 oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# initialize autocomplete here, otherwise functions won't be loaded
autoload -Uz compinit && compinit

# Set up PATH
CORE="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
HOMEBREW="/opt/homebrew/bin:/opt/homebrew/sbin"
DOTFILES_BIN="$DOTFILES/bin"
DENO="~/.deno/bin"
MYSQL="/usr/local/mysql/bin"
POSTGRES="/Applications/Postgres.app/Contents/Versions/12/bin"
export PNPM_HOME="~/Library/pnpm"
export PATH="$CORE:$DOTFILES_BIN:$HOMEBREW:$ZSH:$DENO:$MYSQL:$POSTGRES:$PNPM_HOME"

# Add aliases
source $DOTFILES/config/aliases.zsh

# Set up fasd
eval "$(fasd --init auto)"

# Load nvm
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh