# 🚀 jth dotfiles

**From zero to the perfect dev environment**

These dotfiles include config and settings for:

- Programs and applications to install with Homebrew
- Mac OS default settings
- VSCode settings, keybindings, extensions, and workspaces
- Vim and tmux config (although I now use VSCode)
- Zsh config and aliases
- Alfred settings
- iTerm settings
- Snipster snippets
- Fonts to install
- Git config

## New Mac Set-Up

1. `xcode-select --install`
2. `cd && mkdir <your code repo>` (for me, `cd && mkdir coprime`)
3. Log into Github and create a [personal access token](https://github.com/settings/tokens)
4. `git clone https://github.com/jhanstra/dotfiles` in your projects directory. Use github token to auth.
5. `cd dotfiles && sh mac.sh`. Answer the few questions in there.
6. Continue through the rest of the manual steps that can't be automated: [[Notion]](https://www.notion.so/coprime/New-Mac-Checklist-cba48cca794d4905a12d5fad81b4b851)
