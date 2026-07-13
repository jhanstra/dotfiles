#!/bin/zsh
# Personal additions loaded after Headway's managed Zsh configuration

source "$HOME/.dotfileconfig"

# Use my personal zsh set-up instead of Headway's managed shell
source "$DOTFILES/config/zsh/zshrc.zsh"
source "$DOTFILES/adapters/headway/config/functions.zsh"

# Headway-specific env vars
export JIRA_USER_EMAIL="jared.hanstra@findheadway.com"
