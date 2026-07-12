# Git Configuration

`.gitconfig` contains git config I want on both personal and work contexts. mac.sh links
it to Git's native XDG location at `~/.config/git/config`.

Personal overrides live in `.gitconfig.personal` for things like name and email updates. Work identity lives inside each company adapter in the config folder, e.g. `adapters/headway/config/.gitconfig.work`.

On a personal Mac, `mac.sh` links:

- `.gitconfig` to `~/.config/git/config`
- `.gitignore` to `~/.config/git/ignore`
- `.gitconfig.personal` to `~/.gitconfig`

The personal identity file includes its sibling `.gitconfig`, so Git loads both
the shared behavior and personal identity.

On a work Mac, the company owns `~/.gitconfig`. `mac.sh` links the shared config
and ignore files into the XDG locations and links the selected adapter's
`.gitconfig.work` to `~/.gitconfig.local`. The work identity file includes the
repository's shared config.

Inspect the final merged configuration with:

```sh
git config --list --show-origin --show-scope
```
