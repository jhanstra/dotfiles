# Git Configuration

`.gitconfig` contains portable Git behavior shared across machines. Setup links
it to Git's native XDG location at `~/.config/git/config`.

Personal identity lives in `.gitconfig.personal`. Work identity lives with each
company adapter, such as `adapters/headway/config/.gitconfig.work`.

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
