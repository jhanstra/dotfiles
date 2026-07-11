#!/bin/zsh

# Resolve the dotfiles repository from this file, even when it is symlinked
# into a company-managed zsh extension directory
ADAPTER_SOURCE="${${(%):-%N}:A}"
export DOTFILES="${ADAPTER_SOURCE:h:h:h:h}"
unset ADAPTER_SOURCE

# Headway owns the prompt, completion initialization, and other shell framework
# behavior. Load the portable dotfiles configuration without a second oh-my-zsh
export DOT_CTX="work"
export DOTFILES_ENABLE_OH_MY_ZSH=0
source "$DOTFILES/config/zsh/zshrc.zsh"

# Headway-specific environment values that should not load on personal macs
export JIRA_USER_EMAIL="jared.hanstra@findheadway.com"
