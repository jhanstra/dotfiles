# AI Configuration

Coprime is the source of truth for portable AI guidance. This repository stores the generated snapshot needed on machines that do not have access to Coprime.

Do not edit `generated/` directly. From the Coprime repository, run:

```sh
bun run ai-export
```

Tag portable source sections in Coprime with `ai:universal` markers. Authoring instructions live there under `ai/`.
Whole portable files and directories are listed in Coprime's `ai/universal.json`.

## Installed Targets

`mac.sh` installs the generated guidance for:

- Cursor: `generated/cursor` → `~/.cursor/plugins/local/jth`
- Claude Code instructions: `generated/shared/AGENTS.md` → `~/.claude/CLAUDE.md`
- Codex instructions: `generated/shared/AGENTS.md` → `~/.codex/AGENTS.md`
- OpenCode instructions: `generated/shared/AGENTS.md` → `~/.config/opencode/AGENTS.md`
- Claude Code skills: `generated/skills/*` → `~/.claude/skills/*`
- Codex skills: `generated/skills/*` → `~/.agents/skills/*`

Cursor agents, commands, hooks, and MCP configuration belong inside `generated/cursor/` so the local plugin carries them. Add an explicit `safe_link` or `link_dir` call in `mac.sh` when introducing another tool-native generated target. Tool-specific formats are not interchangeable.

Restart the relevant agent after the first install. For Cursor, run **Developer: Reload Window** or restart the application.

Generated guidance must remain universal: no credentials, employer-owned material, repository-specific paths, or Coprime-only tools and packages.
