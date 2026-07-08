#!/usr/bin/env bash
# PreToolUse hook — protect uncommitted work in the PRIMARY checkout (main).
#
# Companion to block-main-edits.sh. That hook stops Claude's Edit/Write tools
# from touching the main working tree. This one closes the OTHER hole: a `git`
# command run through the Bash tool can still rewrite (or clobber) files in the
# primary checkout — e.g. `git merge`, `git reset --hard`, `git checkout -- .`,
# `git clean`, `git stash pop`. When foreign, uncommitted work is sitting on
# main (another session, Cowork, hand edits), such an op can tangle with or
# silently destroy it.
#
# Policy: deny a tree-mutating git command ONLY when its TARGET repo is the
# primary checkout AND that working tree is DIRTY. A clean tree is the normal
# state for the merge-back step of the worktree flow, so it stays allowed.
# The remedy the deny message points to (commit, or `git stash push -u`) is what
# SURFACES foreign work instead of overwriting it.
#
# Fails OPEN on any uncertainty (no repo, missing tools, unparsable payload,
# non-git command) so a bug here can never wedge a session — it only ever blocks
# the clear dirty-primary-checkout case.
#
# Override: ALLOW_MAIN_EDITS=1 set when LAUNCHING claude (same escape hatch as
# block-main-edits.sh; an agent's Bash subshell cannot inject it here). Not
# mentioned in the deny message on purpose.
set -u

allow() { exit 0; }
deny() {
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Diese git-Operation veraendert das Arbeitsverzeichnis des primaeren Checkouts (main), das gerade uncommittete Aenderungen hat — sie koennte fremde Arbeit ueberschreiben. Bitte zuerst sichern: committen, oder 'git stash push -u -m wip' (ggf. fremde Arbeit), dann erneut versuchen. Fuer eigene Aenderungen gilt weiterhin Worktree-first."}}
JSON
  exit 0
}

[ -n "${ALLOW_MAIN_EDITS:-}" ] && allow

payload="$(cat 2>/dev/null)" || allow

# Pull the Bash command string out of the tool payload. No command → not a Bash
# tool call we care about → allow.
cmd=""
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)"
fi
[ -z "$cmd" ] && cmd="$(printf '%s' "$payload" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)"[[:space:]]*}.*/\1/p' | head -n1)"
[ -z "$cmd" ] && allow

# Does the command invoke git with a WORKING-TREE-MUTATING subcommand? Match the
# verb as a token following a `git ...` (excluding anything past a pipe/;/&& so a
# downstream `grep merge` etc. doesn't trip it). Loose but targeted; false
# negatives just fall through to git's own safety checks.
mutates=0
grep -Eq '\bgit\b[^|;&]*\b(merge|rebase|cherry-pick|revert|am)\b' <<<"$cmd" && mutates=1
grep -Eq '\bgit\b[^|;&]*\breset\b[^|;&]*--hard'                    <<<"$cmd" && mutates=1
grep -Eq '\bgit\b[^|;&]*\b(checkout|switch|restore)\b'             <<<"$cmd" && mutates=1
grep -Eq '\bgit\b[^|;&]*\bclean\b'                                 <<<"$cmd" && mutates=1
grep -Eq '\bgit\b[^|;&]*\bstash\b[^|;&]*\b(pop|apply)\b'           <<<"$cmd" && mutates=1
[ "$mutates" -eq 1 ] || allow

# Resolve the TARGET repo dir: honour `git -C <dir>` if present, else the
# session cwd. (Strip one layer of surrounding quotes.)
dir="$PWD"
cdir="$(sed -n 's/.*git[[:space:]]\{1,\}-C[[:space:]]\{1,\}\([^ ]\{1,\}\).*/\1/p' <<<"$cmd" | head -n1)"
cdir="${cdir%\"}"; cdir="${cdir#\"}"; cdir="${cdir%\'}"; cdir="${cdir#\'}"
[ -n "$cdir" ] && dir="$cdir"

# Inspect the target repo. Fail open if git can't answer.
gitdir="$(git -C "$dir" rev-parse --absolute-git-dir 2>/dev/null)" || allow
[ -n "$gitdir" ] || allow
commondir="$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null)"
case "$commondir" in
  "") commondir="$gitdir" ;;
  /*) ;;
  *)  commondir="$(cd "$dir" 2>/dev/null && cd "$commondir" 2>/dev/null && pwd)" ;;
esac
# Linked worktree (git-dir differs from the common dir) → not the primary → fine.
[ "$gitdir" != "$commondir" ] && allow

# Primary checkout. Block only when the tree carries uncommitted TRACKED work —
# modified / staged / deleted files (what a merge/checkout/reset would actually
# clobber, and exactly the shape of the incident this guards). Untracked litter
# (err.tmp, build logs, nested worktree dirs) is ignored (-uno) so it never
# nuisance-blocks a clean merge-back.
status="$(git -C "$dir" status --porcelain --untracked-files=no 2>/dev/null)"
[ -z "$status" ] && allow

deny
