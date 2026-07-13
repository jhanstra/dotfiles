# oh-my-zsh is a framework that configures zsh and provides themes, plugins,
# completions, aliases, and other interactive-shell conveniences

# Allow managed work environments to disable Oh My Zsh before sourcing this file
if [[ "${DOTFILES_ENABLE_OH_MY_ZSH:-1}" != "1" ]]; then
  return
fi

# Tell oh-my-zsh where it is installed
export ZSH="$HOME/.oh-my-zsh"

# Enable Git aliases and repository-aware shell helpers
plugins=(
  git
  colored-man-pages # Add colors to man-page headings and examples
  last-working-dir # Reopen new shells in the last directory used by the previous shell
  thefuck # Enable aliases and correction support for thefuck command
)

# Use oh-my-zsh's built-in robbyrussell prompt theme
ZSH_THEME="robbyrussell"

# Load oh-my-zsh after all configuration above has been declared
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi
