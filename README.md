# 🚀 jth dotfiles

## from zero to the perfect dev environment

config and setup for:

- cli tools and apps (all installed with homebrew)
- language runtimes with mise (node, ruby, python, etc)
- better macos default settings
- cursor / vscode settings, keybindings, extensions
- portable agent rules, skills, hooks, etc
- neovim and tmux configuration
- zsh config and aliases
- git config
- alfred settings
- fonts
- personal and work macs

## new mac setup

1. on a work mac, run the company's official bootstrap first and configure a company adapter as described below
2. make sure `git` works; on a fresh personal mac, run `xcode-select --install` and wait for it to finish
3. clone this repo:

   ```sh
   mkdir -p ~/code
   git clone https://github.com/jhanstra/dotfiles ~/code/dotfiles
   cd ~/code/dotfiles
   ```

4. run `bash mac.sh`
5. choose `personal` or `work` and confirm the code and dotfiles paths
6. stick around for the interactive setup near the beginning:
   - app store sign-in
   - ssh key creation
   - npm login
   - oh my zsh installation
   - xcode installation
7. once the interactive setup finishes, walk away while the remaining tools, apps, runtimes, fonts, and editor extensions install
8. open a new terminal after setup completes

the answers are saved in `~/.dotfileconfig`, so rerunning `bash mac.sh` reuses the same context and paths

## personal vs work

both contexts install the shared brewfiles, shell tools, runtimes, config, fonts, and editor setup

personal macs also:

- link the personal git identity
- install `config/homebrew/Brewfile.apps.personal`

work macs also:

- link company-specific git config without replacing the company-managed global identity
- install company-specific apps
- run the company adapter

### work adapters

an adapter connects the shared dotfiles to extension points supported by a company-managed mac. it should not replace the company's bootstrap, managed files, security controls, or version managers

`adapters/headway/` is the adapter for the owner of this repo, not a default for other users. if you fork this repo for another company:

1. run the company's official setup first
2. inspect which shell, git, package, and dotfile locations it manages
3. create `adapters/<company>/` using the structure and safety checklist in `adapters/README.md`
4. include an `adapt.sh`, `config/.gitconfig.work`, `config/Brewfile.apps.work`, and `config/zsh-config.zsh`
5. update the work-only paths at the bottom of `mac.sh` from `adapters/headway/` to your adapter
6. keep company secrets and proprietary config out of this repo

the included headway adapter uses its supported `~/.zshrc.d` extension point as an example

## rerunning setup

`bash mac.sh` is safe to rerun on a mac with the same context, repo path, and company adapter

interactive steps are checked and skipped when already complete:

- app store is signed in, or confirmed when `mas` cannot inspect the account
- github is authenticated
- an ed25519 ssh key exists
- npm is authenticated
- oh my zsh is installed
- xcode is installed

homebrew bundles, mise, defaults, fonts, and editor extensions still run their checks. they should not duplicate existing state. homebrew packages may update over time; mise runtimes change only when their pinned versions are updated

unknown files, different symlinks, and partial installs are refused instead of overwritten

## updating the setup

- shared bootstrap tools: `config/homebrew/Brewfile.bootstrap`
- shared cli tools: `config/homebrew/Brewfile.cli`
- shared apps: `config/homebrew/Brewfile.apps`
- shared fonts: `config/homebrew/Brewfile.fonts`
- personal apps: `config/homebrew/Brewfile.apps.personal`
- work apps and config: `adapters/<company>/`
- default language versions: `config/mise/config.toml`
- shell setup and aliases: `config/zsh/`
- cursor / vscode settings and extensions: `config/ide/`
- app settings: `config/{alfred,ghostty,iterm2,rectangle,zed}/`
- optional ollama models: `config/ollama/models.txt`
- portable ai rules and skills: `config/ai/`
- interactive setup: `scripts/interactive.sh`
- other non-homebrew setup: `scripts/install.sh`

pull and apply future updates with:

```sh
cd "$DOTFILES"
git pull
bash mac.sh
```

to change the saved machine context or paths, edit or remove `~/.dotfileconfig`, then rerun setup

### when changes go live

- git config changes apply on the next git command
- zsh, aliases, `.env`, and adapter shell config apply in a new terminal or after `source ~/.zshrc`
- zprofile changes apply in a new login shell
- neovim config applies on the next launch
- tmux config applies after `tmux source-file ~/.config/tmux/tmux.conf` or a restart
- cursor / vscode usually reload linked settings automatically; use `reload window` if needed
- Ghostty, iTerm2, Rectangle, and Zed settings apply after restarting the app
- Alfred requires the one-time sync-folder selection documented in `config/alfred/README.md`
- ai guidance changes apply in new agent sessions; Cursor also needs `developer: reload window` or a restart
- mise version changes require `mise install`
- brewfiles, extension lists, fonts, defaults, installers, and adapter installation changes require `bash mac.sh`

Ollama models are large and intentionally optional. After launching Ollama, install the declared models with:

```sh
bash scripts/install-ollama-models.sh
```

## env setup

copy the example, add only the values this machine needs, and never commit the result:

```sh
cp .env.example .env
```

`config/zsh/zshrc.zsh` loads `.env` and exports its values to commands started from the shell. open a new terminal after changing it

update `.env.example` when adding a new supported variable, but leave real tokens in the ignored `.env`
