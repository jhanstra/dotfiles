# Dotfiles Progress and Next Plan

This document is a checkpoint against `PLAN.md` after the July 2026 cleanup.
It records what is actually complete, what is only partially implemented, and
the recommended order for finishing the repository.

## Current State

- Branch: `master`
- In sync with `origin/master`.
- The current smoke suite passes:
  - Bash and Zsh syntax checks
  - Karabiner generation with Bun
  - Neovim headless startup
  - IDE extension installer dry run
  - Personal offline installer dry run
  - Headway adapter syntax

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
- [x] Personal and managed-shell loading paths pass smoke tests.

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

### Adapter framework

- [x] `adapters/README.md` documents how an agent should inspect a new company
      setup and build a safe adapter.
- [x] A Headway adapter draft exists.
- [x] The adapter preserves Headway-managed Oh My Zsh behavior.
- [x] Company context is explicitly set to `work`.
- [ ] The Headway adapter has not been installed.
- [ ] The existing `~/.zshrc.d/90.my-config.zsh` still contains copied config.

## What Is Partially Done

### Shell portability

- [ ] Load optional local profile, override, and secret files from documented
      paths.
- [ ] Separate personal history ownership from employer-managed history.
- [ ] Decide whether to remove `ZSH_DISABLE_COMPFIX`; current completion
      permissions passed `compaudit`.
- [ ] Finish auditing aliases for Coprime paths, obsolete tools, duplicate
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
- [x] Remove tools now owned by mise or no longer used, including likely
      candidates such as direct Node, pnpm, Ruby, Vim, Yarn, and duplicate
      syntax-highlighting installation.
- [x] Review every cask against software actually used.
- [x] Add new casks and cli tools I don't have in there yet
- [x] Resolve renamed/deprecated casks.
- [x] Decide whether `fullBrew.sh` should be deleted; it remains as legacy
      content.

### IDE profile behavior

- [x] Decide whether work and personal machines need different IDE settings.
- [x] If so, generate merged settings from shared and profile-specific inputs
      instead of linking one file everywhere.
- [x] Review the old Coprime workspace and either archive or delete it.

## What Is Not Done

### Safe bootstrap architecture

The current `mac.sh` is still the largest reliability gap.

- [x] Add an explicit Bash shebang and strict/error-aware structure.
- [x] Make Homebrew available in the current process immediately after install.
- [x] Keep the main bootstrap linear and free of command-line modes.
- [ ] Back up or refuse unknown files before replacing them.
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

- [ ] Review every default against current macOS.
- [x] Remove duplicated and obsolete settings; unused defaults live in
      `config/archived/mac-defaults-archived.sh`.

### Validation and documentation

- [ ] Replace the stale Coprime-era new-Mac instructions in `README.md`.
- [ ] Document personal setup separately from company adapter setup.
- [ ] Add automated shell/config smoke tests.
- [ ] Add a command that checks for broken symlinks and missing dependencies.
- [ ] Test a clean personal installation in a VM or disposable account.
- [ ] Test rerunning the installer.

## Remaining Legacy/Bloat Decisions

- [ ] Alfred preferences: approximately 110 MB and not currently configured as
      an active sync folder.
- [ ] Fonts: approximately 27 MB; verify which families are still used.
- [x] `config/homebrew/fullBrew.sh`: legacy package dump.
- [x] Coprime workspace: stale paths and old startup commands.
- [x] Archived content: retain intentionally or move to a separate archive.

## Recommended Next Order

1. Finish the Headway adapter: source `aliases.zsh`, install it, remove
   duplicated `90.my-config`.
2. Rewrite `mac.sh` into a context-aware, idempotent orchestrator.
3. Create the standalone personal Mac adapter.
4. Finish the aliases audit and Brewfile cleanup (mise-owned tools, deprecated
   casks, new tools).
5. Decide Alfred, fonts, workspace, `fullBrew.sh`, and other legacy content.
6. Add tests and run a clean personal-Mac installation.
7. Update the main README to match the final workflow.

## Definition of Done

- One command safely configures a personal Mac.
- A work Mac runs only a company adapter and never overwrites managed files.
- Shared configuration has one source of truth.
- Machine, company, and secret values are layered separately.
- Running setup twice is harmless.
- A clean personal environment passes automated smoke tests.
- Documentation accurately describes both personal and work setup.
