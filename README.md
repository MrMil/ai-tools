# ai-tools

Reusable instructions for AI coding agents (Claude Code and similar).

## Contents

### [`global-claude-md/CLAUDE.md`](global-claude-md/CLAUDE.md)

Personal working agreements for all projects. Currently one rule: never commit, push, rebase or rewrite history unless explicitly asked.

**Install** — copy it to `~/.claude/` (this overwrites any existing `~/.claude/CLAUDE.md`; merge by hand if you have one):

```bash
cp global-claude-md/CLAUDE.md ~/.claude/CLAUDE.md
```

### [`never-commit-hook/git-history-guard.sh`](never-commit-hook/git-history-guard.sh)

A Claude Code `PreToolUse` hook that enforces the rule above. Any Bash command that writes or publishes git history (`commit`, `push`, `rebase`, `reset`, `revert`, `cherry-pick`, `am`, `filter-branch`, `reflog delete`) triggers an explicit approval prompt instead of running silently. Requires `jq`.

**Install** — copy it to `~/.claude/hooks/`:

```bash
mkdir -p ~/.claude/hooks && cp never-commit-hook/git-history-guard.sh ~/.claude/hooks/git-history-guard.sh && chmod +x ~/.claude/hooks/git-history-guard.sh
```

Then register it in `~/.claude/settings.json` (merge into any existing `hooks` block):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/git-history-guard.sh",
            "timeout": 10,
            "statusMessage": "Checking git write guard..."
          }
        ]
      }
    ]
  }
}
```

### [`meta-documentation/docs-infect.md`](meta-documentation/docs-infect.md)

A one-time install prompt that sets up a self-maintaining documentation system in any repo: a recursive `docs/` tree of hub `README.md` pages mirroring the system, a `docs/CONVENTIONS.md`, and standing rules patched into `AGENTS.md` / `CLAUDE.md` / `README.md` so new work carries its own docs — including *why* each decision was made.

**Install** — open an agent (e.g. Claude Code) in the target repo and give it this prompt:

```text
Follow the instructions in /path/to/ai-tools/meta-documentation/docs-infect.md exactly.
```
