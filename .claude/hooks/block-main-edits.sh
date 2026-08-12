#!/usr/bin/env bash
# PreToolUse hook — enforce "worktree-first".
#
# Denies Edit/Write/MultiEdit/NotebookEdit when the SESSION is operating in the
# PRIMARY git checkout (the main working tree). Allows when:
#   - the session is inside a linked git worktree (abs git-dir != common dir),
#   - the edited file is OUTSIDE the repo (e.g. ~/.claude memory, /tmp scratchpad).
#
# There is NO file-based escape hatch on purpose: an agent could just `touch` it
# to self-authorize (and an earlier version did). The only override is the env
# var ALLOW_MAIN_EDITS=1, which must be set when LAUNCHING claude — an agent's
# Bash subshells cannot inject it into this hook's process. It is deliberately
# NOT mentioned in the deny message below, so a blocked agent isn't handed the
# bypass.
#
# Fails OPEN on any uncertainty (no repo, missing tools, unparsable payload) so a
# bug here can never wedge a session — it only ever blocks the clear
# primary-checkout case.
set -u

deny() {
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Editieren im primaeren Checkout (main) ist blockiert (Worktree-first). Bitte zuerst EnterWorktree aufrufen, um in einem eigenen Branch + Ordner zu arbeiten; dann erneut versuchen."}}
JSON
  exit 0
}
allow() { exit 0; }

# Override: env var set at launch only (agent Bash cannot reach this process env).
# Intentionally NO file-based hatch — that was self-defeating (agents `touch` it).
[ -n "${ALLOW_MAIN_EDITS:-}" ] && allow

payload="$(cat 2>/dev/null)" || allow

# Inside a git repo? Anchor on the session's working directory.
toplevel="$(git rev-parse --show-toplevel 2>/dev/null)" || allow
[ -n "$toplevel" ] || allow

# Linked worktree? The absolute git-dir differs from the common dir → isolated.
gitdir="$(git rev-parse --absolute-git-dir 2>/dev/null)" || allow
[ -n "$gitdir" ] || allow
commondir="$(git rev-parse --git-common-dir 2>/dev/null)"
case "$commondir" in
  "") commondir="$gitdir" ;;
  /*) ;;
  *)  commondir="$(cd "$commondir" 2>/dev/null && pwd)" ;;
esac
[ "$gitdir" != "$commondir" ] && allow   # in a linked worktree → fine

# Extract the target file path from the tool payload.
fp=""
if command -v jq >/dev/null 2>&1; then
  fp="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)"
fi
[ -z "$fp" ] && fp="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
[ -z "$fp" ] && fp="$(printf '%s' "$payload" | sed -n 's/.*"notebook_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
# No path found → can't judge → allow (fail open).
[ -z "$fp" ] && allow

# Resolve to absolute against the session cwd.
case "$fp" in
  /*) fp_abs="$fp" ;;
  *)  fp_abs="$PWD/$fp" ;;
esac

# Only block edits that land INSIDE the repo; out-of-repo edits are always fine.
case "$fp_abs" in
  "$toplevel"/*|"$toplevel") deny ;;
  *) allow ;;
esac
