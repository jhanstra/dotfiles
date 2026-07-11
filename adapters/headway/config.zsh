#!/bin/zsh

# Resolve the dotfiles repository from this file, even when it is symlinked
# into a company-managed Zsh extension directory.
ADAPTER_SOURCE="${${(%):-%N}:A}"
export DOTFILES="${ADAPTER_SOURCE:h:h:h}"
unset ADAPTER_SOURCE

# Headway owns the prompt, completion initialization, and other shell framework
# behavior. Load the portable dotfiles configuration without a second Oh My Zsh.
export DOTFILES_ENABLE_OH_MY_ZSH=0
source "$DOTFILES/.zshrc"

# Headway-specific environment values that should not load on personal Macs.
export JIRA_USER_EMAIL="jared.hanstra@findheadway.com"
