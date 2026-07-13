# Dotfiles Progress and Next Plan

This document is a checkpoint against `PLAN.md` after the July 2026 cleanup.
It records what is actually complete, what is only partially implemented, and
the recommended order for finishing the repository.

## Current State

- Development branch: `main`.
- The full personal setup completed successfully on this Mac on July 13, 2026.
- `mac.sh` is now the context-aware entry point for personal and work setup.
- The personal path is implemented and real-machine validated.
- The Headway/work path is implemented but has not yet been installed and
  validated on the work Mac.
- Validation is currently manual; there is not yet a committed automated smoke
  test runner.

## What Is Done

### Secrets and accidental files

- [x] `.env` is ignored.
- [x] `.env.example` documents empty environment keys.
- [x] Plaintext Jira and Anthropic credentials were removed from tracked config.
- [x] `TEST` and `TEST2` are gone.
- [x] Confirm all exposed credentials were rotated; repository state cannot
      prove that external revocation happened.

### Canonical Zsh configuration

- [x] Canonical config lives under `config/zsh/`.
- [x] Aliases have one source of truth.
- [x] PATH preserves employer/macOS configuration.
- [x] Homebrew-only client paths use the dynamic Homebrew prefix.
- [x] mise replaces nvm, fnm, pyenv, and rbenv shell initialization.
- [x] zoxide replaces fasd.
- [x] Completions are centralized without running `compinit` twice.
- [x] Oh My Zsh is isolated and can be disabled by an adapter.
- [x] The personal shell-loading path completed a real-machine run.
- [ ] Validate the managed-shell loading path on the work Mac.

### Repository organization

- [x] Homebrew config lives in `config/homebrew/`.
- [x] Git config lives in `config/git/`.
- [x] IDE config lives in `config/ide/`.
- [x] Zsh config lives in `config/zsh/`.
- [x] Neovim and tmux files live in `config/vim+tmux/`.
- [x] Old Vim configuration is preserved but inactive in `config/archived/`.
- [x] Old iTerm, IINA, and snippet data is archived.

### Karabiner

- [x] TypeScript is the source of truth.
- [x] Generated JSON lives only in `config/karabiner/karabiner.json`.
- [x] Generation no longer hardcodes the repository path.
- [x] Bun is the only package manager.
- [x] npm, pnpm, and Yarn lockfiles were removed.
- [x] `bun run build` succeeds.

### IDEs

- [x] VS Code and Cursor share generic `settings.json` and `keybindings.json`.
- [x] Active symlinks were repaired after file moves.
- [x] Extensions are listed once in `extensions.txt`.
- [x] One installer loops over VS Code and Cursor.
- [x] Extension installation supports `--dry-run`.

### Neovim

- [x] The active Neovim config is tracked as `config/vim+tmux/nvim.lua`.
- [x] Plugin versions are tracked as `neovim-plugins.json`.
- [x] Setup maps repository names to the filenames Neovim/Lazy.nvim require.
- [x] This Mac currently uses repository-backed symlinks.
- [x] `vim` and `v` invoke Neovim while preserving the no-argument directory
      browser behavior.

### Personal offline support

- [x] Legacy pnpm commands were migrated to Bun.
- [x] Package and repository lists are declarative.
- [x] The installer is optional and never part of normal bootstrap.
- [x] Actual writes require `DOT_CTX=personal`.
- [x] Work and unknown contexts are rejected.
- [x] Dry-run, package-only, and repository-only modes are supported.

### Personal bootstrap and automation

- [x] One `mac.sh` entry point configures a personal Mac.
- [x] Personal context is persisted in `~/.dotfileconfig`.
- [x] The full personal path completed successfully on this Mac.
- [x] Repository cloning is declarative through `config/repos.tsv`.
- [x] Login/startup apps are declarative through `config/startup.tsv`.
- [x] Startup apps can be maintained by the launchd agent in
      `config/launchd/com.jth.dotfiles.startup-apps.plist`.
- [x] Context-specific settings live in `config/contexts/settings.sh`.
- [x] Homebrew is split into bootstrap, CLI, app, personal app, font, and Mac
      App Store manifests.
- [x] Password-requiring package casks are deferred to `sudo.sh`.
- [x] Shared AI configuration, shell functions, and AI shell functions are
      linked from the repository.
- [x] Ollama model installation is available as an optional script rather than
      running during normal bootstrap.

### Adapter framework

- [x] `adapters/README.md` documents how an agent should inspect a new company
      setup and build a safe adapter.
- [x] A Headway adapter draft exists.
- [x] The adapter preserves Headway-managed Oh My Zsh behavior.
- [x] Company context is explicitly set to `work`.
- [ ] The Headway adapter has not been installed.
- [ ] The existing `~/.zshrc.d/90.my-config.zsh` still contains copied config.
- [ ] The Headway-specific `aliases.zsh` exists but is not yet sourced by the
      adapter configuration.

## What Is Partially Done

### Shell portability

- [x] Load optional local profile, override, and secret files from documented
      paths.
- [x] Separate personal history ownership from employer-managed history.
- [x] Remove `ZSH_DISABLE_COMPFIX`; completion permissions pass `compaudit`.
- [x] Finish auditing aliases for Coprime paths, obsolete tools, duplicate
      aliases, destructive Git shortcuts, and GNU-only flags.
- [ ] Move general environment values into a focused environment module if
      continued modularization is useful.

### Headway adapter

- [ ] Compare `90.my-config.zsh` with the canonical aliases and functions.
- [ ] Move reusable personal content into this repository.
- [ ] Keep Headway-only functions in the Headway adapter or a Headway-owned
      local file.
- [ ] Replace/remove `90.my-config.zsh`.
- [ ] Use a clear installed filename instead of an unexplained numeric name if
      Headway ordering does not require one.
- [ ] Install the adapter and open a clean shell.
- [ ] Run Headway repair/chezmoi apply and confirm the adapter survives.

### Homebrew and tool ownership

- [x] Split the current Brewfile into core CLI tools and personal GUI apps.
- [x] Consolidate non-Homebrew setup in `scripts/install.sh`.
- [x] Remove duplicate nvm/Bun installers and Git-cloned syntax highlighting;
      Homebrew/mise now own those tools.
- [x] Keep personal defaults, fonts, and non-Homebrew installers out of work
      context.
- [x] Finish reviewing CLI packages that may overlap with mise or no longer be
      needed, including pnpm, Vim, and Yarn.
- [x] Review every cask against software actually used.
- [x] Add new casks and cli tools I don't have in there yet
- [x] Resolve renamed/deprecated casks.
- [x] Delete the legacy `fullBrew.sh` package dump.

### IDE profile behavior

- [x] Decide that work and personal machines can use one shared IDE profile.
- [x] Link the shared settings and keybindings without per-context generation.
- [x] Review the old Coprime workspace and either archive or delete it.

## What Is Not Done

### Safe bootstrap architecture

The personal bootstrap architecture is implemented and has completed a
real-machine run.

- [x] Add an explicit Bash shebang and strict/error-aware structure.
- [x] Make Homebrew available in the current process immediately after install.
- [x] Keep the main bootstrap linear and free of command-line modes.
- [x] Refuse unknown files instead of replacing them.
- [x] Create required VS Code/Cursor parent directories.
- [x] Make every operation safe to repeat.
- [x] Replace `curl | shell` installers where practical.
- [x] Remove nvm installation because mise is the chosen version manager.
- [x] Reconcile Bun, pnpm globals, and mise ownership: mise owns Node, Bun,
      and pnpm; JavaScript project tools are not installed globally.
- [x] Remove the stale `rm -rf /Users/jth/~` line.
- [x] Generate an Ed25519 SSH key only when no suitable key exists.
- [x] Stop prompting for or overwriting company-managed global Git identity.
- [x] Make macOS defaults and font installation explicit opt-ins.

### Git configuration

- [x] Update `mac.sh` to use `config/git/.gitconfig` and
      `config/git/.gitignore` only for personal Macs.
- [x] Separate portable Git aliases/settings from work identity and
      company-managed includes.
- [x] Use `.gitconfig.local` and Git's native include mechanism for identity.
- [x] Link context-specific Git identity directly from `mac.sh`.
- [x] Remove stale KDiff3, SourceTree, Indeed, and wrong-user paths.

### tmux

- [x] Decide whether tmux is still actively used - yes
- [x] Link `config/vim+tmux/.tmux.conf` and install/configure TPM.
- [x] Keep tmux active rather than marking it archived in the folder README.

### macOS defaults

- [x] Review every default against current macOS.
- [x] Remove duplicated and obsolete settings; unused defaults live in
      `config/archived/mac-defaults-archived.sh`.

### Validation and documentation

- [x] Replace the stale Coprime-era new-Mac instructions in `README.md`.
- [x] Document personal setup separately from company adapter setup.
- [ ] Add automated shell/config smoke tests.
- [ ] Add a command that checks for broken symlinks and missing dependencies.
- [x] Complete a successful full personal setup on this Mac.
- [ ] Test a clean personal installation in a VM or disposable account.
- [ ] Test rerunning the installer.

## Remaining Legacy/Bloat Decisions

- [ ] Alfred preferences: approximately 110 MB and not currently configured as
      an active sync folder.
- [ ] Fonts: approximately 27 MB; verify which families are still used.
- [x] Remove `config/homebrew/fullBrew.sh`.
- [x] Coprime workspace: stale paths and old startup commands.
- [x] Archived content: retain intentionally or move to a separate archive.

## Recommended Next Order

1. Finish the Headway adapter: source its Headway-only aliases, install it,
   remove duplicated `90.my-config`, and verify it survives chezmoi apply.
2. Finish the aliases, local-profile, history, and completion-permissions audit.
3. Add an automated smoke runner plus broken-symlink and dependency checks.
4. Rerun the personal installer, then test from a VM or disposable account.
5. Review current macOS defaults and decide whether defaults/fonts need
   explicit opt-in flags.
6. Decide what to retain from Alfred preferences and the remaining font set.

## Definition of Done

- [x] One command safely configures a personal Mac.
- [ ] A work Mac runs only a company adapter and never overwrites managed files.
- [x] Shared configuration has one source of truth.
- [ ] Machine, company, and secret values are fully layered separately.
- [ ] Running setup twice has been explicitly validated.
- [ ] A clean personal environment passes automated smoke tests.
- [x] Documentation describes both personal and work setup.
