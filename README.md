# 🚀 jth dotfiles

**from zero to the perfect development environment in just a few commands**

There are many parts to this dotfiles repo:

- Programs and applications to install with Homebrew
- Keyboard setup with Karabiner
- Mac OS default settings
- Hammerspoon config
- VSCode settings and extensions
- Vim config
- Bash functions and aliases
- Snipster snippets
- Zsh config
- Hyper terminal config

The contents of this repo are organized by topic, inspired by Zach Holman's [dotfiles](https://github.com/holman/dotfiles). Anything in a topic folder with an extension of .zsh will get automatically included into your shell. Anything with an extension of .symlink will get symlinked without extension into \$HOME when you run script/bootstrap.

## components

There are a few special files in the hierarchy.

- **bin/**: Anything in bin/ will get added to your \$PATH and be made available everywhere.
- **Brewfile**: This is a list of applications for Homebrew Cask to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
- **topic/\*.zsh**: Any files ending in .zsh get loaded into your environment.
- **topic/path.zsh**: Any file named path.zsh is loaded first and is expected to setup \$PATH or similar.
- **topic/completion.zsh**: Any file named completion.zsh is loaded last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named install.sh is executed when you run script/install. To avoid being loaded automatically, its extension is .sh, not .zsh.
- **topic/\*.symlink**: Any file ending in \*.symlink gets symlinked into your \$HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run script/bootstrap.

## scripts

`sh bash-scripts/bootstrap.sh`

This is the main script to get everything set up. Sets up your gitconfig, then symlinks all `.symlink` files to your home directory. You will want to edit zsh/zshrc.symlink, which sets up a few paths that'll be different on your particular machine. Since your dotfiles are symlinked from your home folder to here, you can edit everything from here and it will take effect.

`sh bash-scripts/install.sh`

Installs all applications in `Brewfile` using Homebrew and goes through each topic and runs the contents of `install.sh`.

`npm run start`

This command should do _everything_, almost completely setting up a Mac from scratch. It will first run the bootstrap script, then install all of your programs, then set your Mac defaults, then set up VSCode and Karabiner.

`npm run bootstrap`

This is the main script to get everything set up. Sets up your gitconfig, then symlinks all `.symlink` files to your home directory. You will want to edit zsh/zshrc.symlink, which sets up a few paths that'll be different on your particular machine. Since your dotfiles are symlinked from your home folder to here, you can edit everything from here and it will take effect.

`npm run brew`

Installs all applications in `Brewfile` using Homebrew & Homebrew Cask.

`npm run vscode-install`

Installs all of your VSCode extensions.

`dot`

Installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and run dot from time to time to keep your environment fresh and up-to-date. You can find this script in bin/.

## how to

**add to path**
If you need to add a folder to your path, open `system/_path.zsh` and edit the `PATH` export.

## hammerspoon

Hammerspoon is a powerful way to interact with Mac OS, allowing you to listen for events and react to them, and much more. I don't even really know what I'm talking about because I just started using it, but it looks pretty cool.

**To initialize Hammerspoon, run `npm run symlink`.**

Hammerspoon is responsible for adding Super Duper mode, watching for new devices (like keyboards) to be connected to the computer, and adding emoji everywhere.

=======

#####

## faq

> My aliases aren't working.

Have you opened up a new tab? Is your alias written in the correct format?

## modifier keys

To modify keys, go into System Preferences > Keyboard > Modifier Keys

- change Caps Lock to Escape

## npm offline

The `npm-offline` folder has a `package.json` that aims to list all packages I would ever want to use on a project. The packages were installed once while online, which _should_ allow it to be downloaded offline from now on.

## todo

- more hammerspoon functionality
- set up all keyboards I own automatically with Karabiner
-
