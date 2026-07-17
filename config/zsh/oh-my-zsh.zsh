# oh-my-zsh is a framework that configures zsh and provides themes, plugins,
# completions, aliases, and other interactive-shell conveniences

# Allow managed work environments to disable Oh My Zsh before sourcing this file
if [[ "${DOTFILES_ENABLE_OH_MY_ZSH:-1}" != "1" ]]; then
  return
fi

# Tell oh-my-zsh where it is installed
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR"

# Load the completion dump without repeating compaudit and fpath discovery.
autoload -Uz compinit
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"
if [[ -r "$ZSH_COMPDUMP" ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

autoload -Uz colors && colors
setopt PROMPT_SUBST

# Calculate repository status after the first prompt is usable. Large
# repositories can otherwise block prompt rendering for hundreds of milliseconds.
source "$ZSH/lib/async_prompt.zsh"
zstyle ':omz:alpha:lib:git' async-prompt yes
DISABLE_UNTRACKED_FILES_DIRTY=true

source "$ZSH/lib/git.zsh"
source "$ZSH/plugins/git/git.plugin.zsh"
source "$ZSH/plugins/colored-man-pages/colored-man-pages.plugin.zsh"
source "$ZSH/plugins/last-working-dir/last-working-dir.plugin.zsh"
source "$ZSH/lib/termsupport.zsh"
source "$ZSH/themes/robbyrussell.zsh-theme"

# Keep Ghostty tab titles concise: folder at the prompt, command + folder while running
if [[ "$TERM" == xterm-ghostty ]]; then
  ZSH_THEME_TERM_TAB_TITLE_IDLE="%1~"
  ZSH_THEME_TERM_TITLE_IDLE="%1~"

  _ghostty_tab_title_preexec() {
    emulate -L zsh
    local command_name="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
    title "$command_name · %1~"
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _ghostty_tab_title_preexec
fi
