# 🚀 jth dotfiles

**From zero to the perfect development environment in just a few commands.**

There are many parts to this dotfiles repo:

- Programs and applications to install with Homebrew
- Mac OS default settings
- VSCode settings and extensions
- Vim config
- Keyboard setup with Karabiner
- Zsh functions and aliases
- Snipster snippets
- Zsh config

## New Mac Set-Up

1. Set up a file at `~/.localrc` with the following (or whatever you'd like your projects folder and dotfiles location to be)

```
export PROJECTS=~/<your coding dir>
export ZSH=$HOME/<your coding dir>/dotfiles
```

2. Install Homebrew: https://brew.sh
3. Run `sh scripts/bootstrap.sh` to set up git config and install dotfiles (anything marked `.symlink` in this repo) in your home folder
4. Run `sh scripts/install.sh` to install packages and apps with Homebrew. Keep an eye on the script every once in awhile because you may need to input your Mac password
5. Run `npm run link` to symlink VSCode and Karabiner settings
6. Go into System Preferences > Keyboard > Modifier Keys, map 'Caps Lock' to 'Escape'
7. Sign into stuff: Chrome, Slack, Spotify, 1Password
8. Set up Snipster with `npm run snipster-init`
9. Git clone Coprime projects and get set up with them
10. Set up Alfred, turn off Spotlight
11. Set up Contexts
12. Signing into Chrome should install your extensions, but if not, download the extensions below
13. Copy over media from jhDrive


Google Chrome extensions:
- 1Password
- Instapaper
- HTTPS Everywhere
- Fontface Ninja
- JSON Formatter
- Momentum
- React Dev Tools
- WhatRuns
- Wappalyzer

## todo

[] add Contexts config

## how this repo works

Files with `.symlink` get symlinked as dotfiles to your home folder. Files with `.zsh` get loaded into your zsh shell when it starts. The files in `zsh-setup/` are fancy bash scripts that make your terminal prompt look nice.

## how to

**add to path**
If you need to add a folder to your path, open `config/_path.zsh` and edit the `PATH` export.

## faq

> My aliases aren't working.

Have you opened up a new tab? Is your alias written in the correct format? e.g. `alias md='mkdir'` with no spaces?
