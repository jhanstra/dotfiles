# Company Adapters

Company adapters layer the portable configuration in this repository on top of
an employer-managed development environment. They do not replace company
bootstrap tools, dotfile managers, security controls, package policies, or
required shell configuration.

## Directory Convention

Each company gets a self-contained directory with repository-owned names. It should at minimum look like this:

```text
adapters/
  my-company/
    config/
      .gitconfig.work
      Brewfile.apps.work
      zsh-config.zsh
    adapt.sh
```

- `config/zsh-config.zsh` configures the company overlay and sources this repository's
  canonical `config/zsh/zshrc.zsh`.
- `adapt.sh` owns work shell integration because each company manages shell startup
  differently.
- Source filenames should stay generic. The install target may use a
  company-required name such as `~/.zshrc.d/95.example-company.zsh` when load
  ordering requires it.

## Shell Integration

Do not assume every company manages `~/.zshrc` like Headway does. The adapter
must choose the strategy supported by that company's environment:

- If the company manages `~/.zshrc`, use its documented extension point to load
  `config/zsh-config.zsh`.
- If the company does not manage Zsh startup files, use the repository's
  `safe_link` helper to link the canonical `zshrc.zsh` and `zprofile.zsh`.
- If ownership is unclear or a destination contains an unknown file, refuse to
  replace it and explain the conflict.

`mac.sh` intentionally does not link personal Zsh entry points in work context.
The selected work adapter is responsible for making the shared shell config
available safely.

Keep secrets and proprietary company configuration out of this repository.
Store those in the company secret manager or an untracked local file loaded by
`config/zsh-config.zsh`.

## Create an Adapter with an Agent

Run the company's official machine bootstrap first. Then open this repository
in an agent and use a prompt like:

```text
Create a company adapter under adapters/<company>/ for this Mac.

First, inspect the active shell and dotfile setup read-only. Determine:
- which files are managed by the company;
- whether it uses chezmoi, another dotfile manager, or custom scripts;
- which documented personal override or extension points are supported;
- shell load order and required destination filenames;
- which PATH, prompt, history, completion, version-manager, Git, and package
  settings the company already owns.

Create adapters/<company>/config/zsh-config.zsh and adapt.sh.

Requirements:
- source this repository's canonical config/zsh/zshrc.zsh rather than copying
  its contents;
- never overwrite or edit company-managed source files;
- use a supported unmanaged extension point whenever possible;
- disable portable modules that conflict with company-managed equivalents;
- use generic filenames inside this repository even if the installed target
  requires a company-specific or numerically ordered name;
- keep company-only values in config/zsh-config.zsh and secrets outside Git;
- keep adapt.sh small, direct, idempotent, and correctly quote paths;
- detect missing company prerequisites and explain how to install them;
- explain every destination and why it is safe;
- run syntax checks before applying the adapter.
```

After reviewing the adapter, run:

```sh
adapters/<company>/adapt.sh
```

## Chezmoi-Managed Companies

When a company uses chezmoi:

1. Run `chezmoi managed` to identify files the company will overwrite.
2. Run `chezmoi source-path` to identify the company source repository.
3. Read that repository's customization documentation.
4. Prefer documented unmanaged locations such as `~/.zshrc.d/*.zsh`,
   `~/.profile.d/*.sh`, or `~/.gitconfig.local`.
5. Do not edit generated files or the company's chezmoi source just to load
   personal configuration.

The adapter should coexist with future `chezmoi apply` or company repair runs.

## Verification Checklist

- The installer succeeds on a dry run.
- Running the installer twice is harmless.
- Existing unknown files are never replaced.
- A fresh interactive shell starts without errors.
- Company commands, prompt, completions, and version managers still work.
- Personal aliases and tools load exactly once.
- No secrets appear in Git status or tracked files.
- The company's update/repair command does not remove the adapter.
