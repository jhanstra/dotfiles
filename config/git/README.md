# Git Configuration

`.gitconfig` contains the shared Git baseline for personal and work Macs.
`mac.sh` links it to Git's native XDG location at `~/.config/git/config`.

Personal overrides live in `.gitconfig.personal` for things like name and email updates. Work identity lives inside each company adapter in the config folder, e.g. `adapters/headway/config/.gitconfig.work`.

On a personal Mac, `mac.sh` links:

- `.gitconfig` to `~/.config/git/config`
- `.gitignore` to `~/.config/git/ignore`
- `.gitconfig.personal` to `~/.gitconfig`

Git automatically loads both XDG config and `~/.gitconfig`, combining the shared
behavior with the personal identity.

On a Headway Mac, Git first loads the shared XDG config and then Headway's
managed `~/.gitconfig`. Headway includes `~/.gitconfig.local` as its supported
final extension point, where the adapter links `.gitconfig.work`. This allows
the company baseline to override shared defaults and work-specific values such
as identity to apply last.

Inspect the final merged configuration with:

```sh
git config --list --show-origin --show-scope
```
