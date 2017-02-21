# jared does dotfiles
**the perfect development environment**

In this repo you'll find everything I use to set up a new machine from scratch into the perfect dev machine. It includes everything unique about my dev set-up, and all the shortcuts and settings I use while developing, from snippets to editor settings to terminal aliases to mac os defaults. With this repo, you can:

- Install all applications and programs you need, including GUI apps, via Homebrew and Homebrew Cask. Full list of applications that will be installed is in `Brewfile`.
- Set up the Hyper terminal with a nifty theme/colors, plugins that I like, etc.
- Set up Atom with a nifty theme/colors, plugins, and all of my snippets
- Add a **bunch** of convenient aliases, functions, and shell programs that make development easier
- Set up my Mac with more sensible defaults
- Much, much more

The contents of this repo are organized by topic, inspired by Zach Holman's [dotfiles](https://github.com/holman/dotfiles). Anything in a topic folder with an extension of .zsh will get automatically included into your shell. Anything with an extension of .symlink will get symlinked without extension into $HOME when you run script/bootstrap.


### components

There are a few special files in the hierarchy.

- bin/: Anything in bin/ will get added to your $PATH and be made available everywhere.
- Brewfile: This is a list of applications for Homebrew Cask to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
- topic/\*.zsh: Any files ending in .zsh get loaded into your environment.
- topic/path.zsh: Any file named path.zsh is loaded first and is expected to setup $PATH or similar.
- topic/completion.zsh: Any file named completion.zsh is loaded last and is expected to setup autocomplete.
- topic/install.sh: Any file named install.sh is executed when you run script/install. To avoid being loaded automatically, its extension is .sh, not .zsh.
- topic/\*.symlink: Any file ending in \*.symlink gets symlinked into your $HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run script/bootstrap.

### important scripts

##### bootstrap.sh
This is the main script to get everything set up. Sets up your gitconfig, then symlinks the appropriate files to your home directory. You will want to edit zsh/zshrc.symlink, which sets up a few paths that'll be different on your particular machine. Since your dotfiles are symlinked from your home folder to here, you can edit everything from here and it will take effect.

To run this script, cd into your dotfile directory and type `script/bootstrap`.

##### install.sh
Installs all applications in `Brewfile` (will skip applications already installed) and goes through each topic and runs the contents of `install.sh`.

To run, cd into your dotfile directory and type `scripts/install`.

##### dot
Installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and run dot from time to time to keep your environment fresh and up-to-date. You can find this script in bin/.
