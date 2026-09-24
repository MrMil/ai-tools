#!/usr/bin/env bash
# PreToolUse/Bash guard: force an explicit approval prompt for any git command
# that writes or publishes history.
#
# Rationale: "do not commit unless my most recent message asks for it" is a rule
# the model has to remember. This makes it something the harness enforces, so a
# commit can never ride on a stale authorisation from earlier in a session.
#
# Exit 0 with an "ask" decision => Claude Code prompts the user before running.
# Anything unmatched falls through silently and runs as normal.

set -uo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)"

[ -z "$cmd" ] && exit 0

# git, optional global flags, then a history-writing/publishing subcommand.
# Bounded by [^;&|] so each shell segment is considered on its own.
guarded='\bgit\b[^;&|]*\b(commit|push|rebase|reset|revert|cherry-pick|am|filter-branch|reflog[[:space:]]+delete)\b'

if printf '%s' "$cmd" | grep -qE "$guarded"; then
  jq -nc \
    --arg reason "This git command writes or publishes history. Per your working agreement, every commit/push/rebase/reset needs your explicit go-ahead in your most recent message -- an earlier authorisation does not carry over. Approve only if you just asked for this." \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$reason}}'
fi

exit 0
