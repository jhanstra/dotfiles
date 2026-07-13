# Dotfiles Cleanup Plan

## Goal

Make this repository the single source of truth for personal configuration on:

- Personal Macs, where this repository owns the setup.
- Work Macs, where an employer may manage shell, Git, packages, or other configuration.

Work integrations should use small adapters that connect employer-managed systems to this repository without copying or duplicating personal configuration.

## Principles

1. Keep one canonical `config/zsh/zshrc.zsh` in this repository.
2. Keep aliases and functions in `config/zsh/aliases.zsh`, loaded by the
   canonical Zsh configuration.
3. Preserve configuration supplied by the host or employer.
4. Never overwrite employer-managed files when a supported extension point exists.
5. Adapters should create links or source hooks, not copies.
6. Keep machine, employer, and secret values outside the public repository.
7. Prefer capability flags over assuming every work or personal Mac is configured identically.
8. Make installers idempotent and keep their control flow explicit.
9. Review and approve each cleanup phase before applying it.

## Intended Loading Model

### Personal Mac

```text
~/.zshrc
  -> symlink to dotfiles/config/zsh/zshrc.zsh
  -> dotfiles/config/zsh/aliases.zsh
  -> optional local profile and overrides
```

### Employer-Managed Mac

```text
employer-managed ~/.zshrc
  -> employer-supported extension point
  -> adapter hook
  -> source dotfiles/config/zsh/zshrc.zsh
  -> dotfiles/config/zsh/aliases.zsh
  -> optional local profile and overrides
```

On the current Headway Mac, the extension point is `~/.zshrc.d/*.zsh`. The
eventual adapter should replace the copied configuration in `90.my-config.zsh`
with a minimal hook that sources `config/zsh/zshrc.zsh`.

## Local Configuration

Machine-specific configuration should live outside this repository:

```text
~/.config/jhanstra-dotfiles/profile.zsh
~/.config/jhanstra-dotfiles/local.zsh
~/.config/jhanstra-dotfiles/secrets.zsh
```

Possible profile settings:

```zsh
export DOT_CTX="work"
export CODE_ROOT="$HOME/headway"
export DOTFILES_INSTALL_PACKAGES=0
export DOTFILES_ENABLE_PERSONAL_APPS=0
```

Company-specific functions should live in an untracked local file, an employer-owned setup repository, or a separate private adapter repository.

## Target Repository Shape

```text
.env.example                   # Documented empty secret variables
config/
  zsh/
    zshrc.zsh                  # Canonical interactive Zsh configuration
    zprofile.zsh               # Personal-Mac login and Homebrew setup
    aliases.zsh                # Canonical aliases and functions
    completions.zsh            # Zsh completion paths and integrations
    oh-my-zsh.zsh              # Oh My Zsh plugins and theme
  homebrew/
    Brewfile.core            # Core CLI dependencies
    Brewfile.personal          # Optional personal applications
  vim+tmux/
    nvim.lua                   # Canonical Neovim configuration
    neovim-plugins.json        # Pinned Neovim plugin versions
    .tmux.conf                 # tmux configuration
  archived/
    vimrc.vim                  # Archived Vim configuration
    vim-plugins.vim            # Archived Vim plugin list
scripts/
  install.sh                  # Non-Homebrew installation steps
  interactive.sh              # Interactive setup tasks
  mac-defaults.sh             # macOS defaults
  utils.sh                    # Shared shell utilities
adapters/
  standalone-macos.sh          # Link repo config on personal Macs
  zshrc-d.sh                   # Install a source hook for managed shells
  gitconfig-local.sh           # Use a supported Git override
personal/
  offline/
    install.sh                 # Explicit, guarded personal offline setup
    packages.txt               # Packages to cache with Bun
    repos.tsv                  # Public repositories to clone
mac.sh                         # Bootstrap/orchestrate installation
```

The exact structure can evolve as each phase is approved.

## Phased Work

### Phase 1: Protect Secrets and Accidental Files

- Rotate exposed API tokens.
- Keep real credentials only in ignored or secure local storage.
- Maintain `.env.example` with empty values.
- Remove Vim tutorial artifacts `TEST` and `TEST2`.
- Ensure no secrets are staged or committed.

### Phase 2: Establish Canonical Shell Configuration

- Make `config/zsh/zshrc.zsh` safe to source on personal and managed Macs.
- Preserve the host's existing `PATH`.
- Load `config/zsh/aliases.zsh` from one place.
- Load optional local profile and override files.
- Remove hardcoded employer and machine paths.
- Consolidate overlapping Node and Python version managers.

### Phase 3: Install the Headway Adapter

- Move reusable additions from `~/.zshrc.d/90.my-config.zsh` into this repository.
- Move Headway-only functions into a local or Headway-owned file.
- Replace copied personal configuration with a minimal source hook.
- Verify that Headway's chezmoi updates do not overwrite the adapter.

### Phase 4: Create the Personal Mac Adapter

- Symlink `config/zsh/zshrc.zsh` to `~/.zshrc`.
- Back up an existing unmanaged file before replacing it.
- Link other personal configs only when this repository owns them.
- Add repeated-run safety.

### Phase 5: Separate Core and Profile-Specific Setup

- Keep universal CLI packages in the core Brewfile.
- Move personal GUI applications to a personal Brewfile.
- Let employer automation own required work packages.
- Use local capability/profile settings to choose optional setup.
- Keep large offline caches personal-only and explicitly invoked.

### Phase 6: Handle Other Configuration Safely

- Git: use `.gitconfig.local` or `includeIf`; do not replace managed work identity.
- VS Code/Cursor: generate or merge shared settings with profile overrides.
- Karabiner: use one package manager and make generation path-independent.
- macOS defaults: keep opt-in and separate from required bootstrap behavior.

### Phase 7: Remove Confirmed Legacy Content

Candidates already identified:

- `config/indeedRepos.sh`
- `config/homebrew/fullBrew.sh`
- Duplicate/broken Karabiner JSON location
- Duplicate Karabiner lockfiles
- Old Indeed profile files
- Unused Alfred workflows, iTerm exports, snippets, and fonts after verification

### Phase 8: Documentation and Verification

- Update `README.md` with personal and work installation paths.
- Document adapter requirements for a new employer.
- Add syntax and smoke tests for shell files.
- Test setup on a clean personal account or VM.
- Confirm a second run makes no unintended changes.

## Current Git Strategy

- Do not commit all current changes together.
- Separate portable improvements from Headway-specific machine state.
- Restore or relocate work-only changes.
- Commit small, reviewable phases only after each phase is tested and approved.
