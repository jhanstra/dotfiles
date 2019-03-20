# jared does dotfiles
**from zero to the perfect development environment in just a few commands**

In this repo I keep everything I use to set up a new machine from scratch into the perfect dev machine. There are a ton of productivity hacks in here, including all of my aliases, settings, alfred workflows, scripts, etc. With this repo, you can:

- Install all applications and programs you need, including GUI apps, via Homebrew and Homebrew Cask. Full list of applications that will be installed is in `BrewfileBase` and `BrewfilePersonal`.
- Set up VSCode with all of your settings and snippets
- Add convenient aliases, functions, and shell programs that make development easier
- Set up my Mac with more sensible defaults

The contents of this repo are organized by topic, inspired by Zach Holman's [dotfiles](https://github.com/holman/dotfiles). Anything in a topic folder with an extension of .zsh will get automatically included into your shell. Anything with an extension of .symlink will get symlinked without extension into $HOME when you run script/bootstrap.


## components

There are a few special files in the hierarchy.

- **bin/**: Anything in bin/ will get added to your $PATH and be made available everywhere.
- **Brewfile**: This is a list of applications for Homebrew Cask to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
- **topic/\*.zsh**: Any files ending in .zsh get loaded into your environment.
- **topic/path.zsh**: Any file named path.zsh is loaded first and is expected to setup $PATH or similar.
- **topic/completion.zsh**: Any file named completion.zsh is loaded last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named install.sh is executed when you run script/install. To avoid being loaded automatically, its extension is .sh, not .zsh.
- **topic/\*.symlink**: Any file ending in \*.symlink gets symlinked into your $HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run script/bootstrap.

## scripts
To run any of these scripts, cd into your dotfile directory and type `script/<script_name>`.

##### bootstrap.sh
This is the main script to get everything set up. Sets up your gitconfig, then symlinks all `.symlink` files to your home directory. You will want to edit zsh/zshrc.symlink, which sets up a few paths that'll be different on your particular machine. Since your dotfiles are symlinked from your home folder to here, you can edit everything from here and it will take effect.


##### install-base.sh
Installs all applications in `BrewfileBase` using Homebrew Cask. These are the most common applications that are appropriate for both work and personal and goes through each topic and runs the contents of `install.sh`.

To run, cd into your dotfile directory and type `scripts/install-base`.

##### install-personal.sh
Installs additional personal applications with Homebrew Cask.

To run, cd into your dotfile directory and type `scripts/install-personal`.

##### link.sh
Symlinks your VSCode and Karabiner settings to this repo so you can edit them here.

##### dot
Installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and run dot from time to time to keep your environment fresh and up-to-date. You can find this script in bin/.


## how to

**add to path**
If you need to add a folder to your path, open `system/_path.zsh` and edit the `PATH` export.

**install vscode extensions**
Check out the `extensions.sh` script in the `vscode/` folder.

**add `code .` to path**
open the command palette (⇧⌘P) in vscode and type 'shell command' to find the shell command



#####

## faq
> My aliases aren't working.

Have you opened up a new tab? Is your alias written in the correct format?


## modifier keys
To modify keys, go into System Preferences > Keyboard > Modifier Keys
- change Caps Lock to Escape

## npm offline
The `npm-offline` folder has a `package.json` that aims to list all packages I would ever want to use on a project. The packages were installed once while online, which *should* allow it to be downloaded offline from now on.

## todo
- add a fonts section with all my fonts. install [firacode](https://github.com/tonsky/FiraCode#download-v1205--how-to-install--troubleshooting--news--updates) and other fonts and add to fonts (Mac HD > Library > Fonts)

