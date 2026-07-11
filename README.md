# 🚀 jth dotfiles

**from zero to the perfect dev environment**

config and settings for:

- programs and applications to install with homebrew
- macos default settings
- cursor / vscode settings, keybindings, extensions, and workspaces
- neovim and tmux configuration
- zsh config and aliases
- Alfred settings
- iterm settings
- snipster snippets
- fonts to install
- git config

## new mac set-up

1. `xcode-select --install`
2. `cd && mkdir <your code repo>` (for me, `cd && mkdir coprime`)
3. Log into Github and create a [personal access token](https://github.com/settings/tokens)
4. `git clone https://github.com/jhanstra/dotfiles` in your projects directory. Use github token to auth.
5. `cd dotfiles && sh mac.sh`. Answer the few questions in there.
6. Continue through the rest of the manual steps that can't be automated: [[Notion]](https://www.notion.so/coprime/New-Mac-Checklist-cba48cca794d4905a12d5fad81b4b851)

## Env Set-up

The following are the env tokens I have in .env to automatically add them to the shell for use:

- VERCEL_TOKEN: get from the Vercel settings under your profile
