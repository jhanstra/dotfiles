# Optional Personal Offline Cache

This directory preserves packages and public repositories for development and research
while internet access is unavailable. It is personal-only, optional, large, and never
part of the normal work or personal bootstrap.

Files:

- `packages.txt` lists packages to cache through Bun.
- `repos.tsv` lists public Git repositories and their local paths.
- `install.sh` builds either or both caches.

The installer requires the machine profile to resolve to
`DOT_CTX=personal`. It refuses to make changes on work or unknown
machines. A dry run is allowed anywhere:

```sh
personal/offline/install.sh --dry-run
personal/offline/install.sh --packages-only
personal/offline/install.sh --repositories-only
personal/offline/install.sh
```

The default location is:

```text
${CODE:-$HOME/Code}/offline/
  bun/
  repositories/
```

Override it for one run with `DOTFILES_OFFLINE_ROOT=/some/path`.

The lists came from an older Coprime-era cache and will contain obsolete
packages or repositories over time. Individual failures are reported at the end
without discarding successful downloads.
