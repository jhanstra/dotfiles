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

1. on a work mac, run the company's official bootstrap first
2. make sure `git` works; on a fresh personal mac, run `xcode-select --install` and wait for it to finish
3. clone this repo:

   ```sh
   mkdir -p ~/code
   git clone https://github.com/jhanstra/dotfiles ~/code/dotfiles
   cd ~/code/dotfiles
   ```

4. run `bash mac.sh`
5. choose `personal` or `work` and confirm the code and dotfiles paths
6. stick around for setup steps that may request input near the beginning:
   - xcode update and initialization
   - github login
   - ssh key creation
   - npm login
   - oh my zsh installation
7. the remaining tools, apps, runtimes, fonts, and editor extensions install after the interactive steps
8. if setup reports that administrator-required work remains, run `bash sudo.sh`
9. open a new terminal after setup completes
10. run `agent login` once to authenticate the Cursor Agent CLI

the answers are saved in `~/.dotfileconfig`, so rerunning `bash mac.sh` reuses the same context and paths

## personal vs work

both contexts run the shared bootstrap: homebrew bootstrap and cli packages,
`Brewfile.apps`, fonts, runtimes, editor extensions, application configuration,
macos preferences, repository installers, ai configuration, and startup items.

personal macs also:

- link the personal git identity
- link the canonical zsh and mise configuration
- install `config/homebrew/Brewfile.apps.personal`
- clone the repositories configured for the personal context in `config/repos.tsv`; `owner/*` rows expand GitHub usernames or organizations into a folder, while `owner/repo` rows select individual repositories
- globally install configured repositories whose root `package.json` declares command-line binaries

work macs run the same shared setup, but the selected company adapter uses
supported extension points for locations owned by the company:

- layers work identity over the company-managed git baseline
- layers shared runtime defaults without replacing company-managed mise config
- loads canonical personal zsh preferences through the company's supported
  shell extension point while disabling conflicting features
- leaves company-managed shell entry points, frameworks, and configuration
  files untouched

### work adapters

an adapter connects the shared dotfiles to extension points supported by a company-managed mac. it should not replace the company's bootstrap, managed files, security controls, or version managers

1. run the company's official setup first
2. inspect which shell, git, package, and dotfile locations it manages
3. create `adapters/<company>/` using the structure and safety checklist in `adapters/README.md`
4. include `adapt.sh`, `config/.gitconfig.work`, `config/Brewfile.apps.work`, and `config/zshrc.work.zsh`
5. update the work-only block near the bottom of `mac.sh`
6. keep company secrets and proprietary config out of this repo

## rerunning setup

`bash mac.sh` is safe to rerun on a mac with the same context and repository
path.

interactive setup always runs on the initial setup and is skipped on later runs. use `bash mac.sh -i` to run it again; completed steps are detected and skipped:

- github is authenticated
- an ed25519 ssh key exists
- npm is authenticated
- oh my zsh is installed

use `bash mac.sh -f` to replace existing regular files or symlinks at
repository-owned configuration targets. real directories are still refused.
`-i` and `-f` can be combined in either order.

xcode, homebrew bundles, mise, defaults, fonts, and editor extensions still run
their checks in both contexts. company-managed files are not replaced.

GUI bundles inspect current Homebrew metadata and defer missing or outdated casks backed by privileged `.pkg` installers. `sudo.sh` installs the collected leftovers as a separate interactive step.

unknown files, different symlinks, and partial installs are refused unless
`-f` is explicitly provided

## updating the setup

- shared bootstrap tools: `config/homebrew/Brewfile.bootstrap`
- shared cli tools: `config/homebrew/Brewfile.cli`
- shared apps: `config/homebrew/Brewfile.apps`
- shared Mac App Store apps: `config/homebrew/Brewfile.mas`
- shared fonts: `config/homebrew/Brewfile.fonts`
- personal apps: `config/homebrew/Brewfile.apps.personal`
- work overlay configuration: `adapters/<company>/`
- default language versions: `config/mise/config.toml`
- shell setup and aliases: `config/zsh/`
- cursor / vscode settings and extensions: `config/ide/`
- app settings: `config/{alfred,ghostty,iterm2,rectangle,zed}/`
- optional ollama models: `config/ollama/models.txt`
- repositories to clone: `config/repos.tsv`
- apps and brew services started at login: `config/startup.tsv`
- custom background processes: `config/launchd/`
- portable ai rules and skills: `config/ai/`
- interactive setup: `scripts/interactive.sh`
- other non-homebrew setup: `scripts/install.sh`

Startup entries use `all`, `personal`, or `work` in the first TSV column and
`app` or `service` in the second. App rows can include a file or folder to open
in the optional fourth column. Add a LaunchAgent plist to `config/launchd/` for
a process that is not managed by Homebrew.

pull and apply future updates with:

```sh
cd "$DOTFILES"
git pull
bash mac.sh
```

to change the saved machine context or paths, edit or remove `~/.dotfileconfig`, then rerun setup

### Mac App Store apps

Mac App Store installs and updates require `sudo`, so they are intentionally
separate from `mac.sh`. Run these interactively when wanted:

```sh
brew bundle install --file="$DOTFILES/config/homebrew/Brewfile.mas"
```

### when changes go live

- git config changes apply on the next git command
- zsh, aliases, `.env`, and adapter shell config apply in a new terminal or after `exec zsh`
- zprofile changes apply in a new login shell
- neovim config applies on the next launch
- tmux config applies after `tmux source-file ~/.config/tmux/tmux.conf` or a restart
- cursor / vscode usually reload linked settings automatically; use `reload window` if needed
- Ghostty, iTerm2, Rectangle, and Zed settings apply after restarting the app
- Alfred requires the one-time sync-folder selection documented in `config/alfred/README.md`
- ai guidance changes apply in new agent sessions; Cursor also needs `developer: reload window` or a restart
- mise version changes require `mise install`
- brewfiles, extension lists, fonts, defaults, installers, and adapter installation changes require `bash mac.sh`
- startup app list changes apply at the next login; new launch agents require `bash mac.sh` first

Ollama models are large and intentionally optional. After launching Ollama, install the declared models with:

```sh
bash scripts/ollama.sh
```

## env setup

copy the example, add only the values this machine needs, and never commit the result:

```sh
cp .env.example .env
```

the personal zsh configuration and selected work adapter both load `.env` and
export its values to commands started from the shell. open a new terminal after
changing it.

update `.env.example` when adding a new supported variable, but leave real tokens in the ignored `.env`
