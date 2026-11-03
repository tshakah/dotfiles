#!/bin/sh
# Detached because git-branchless restack moves a branch checked out in another worktree.
# Claude Code reads the worktree path from the last line of stdout, so nothing else goes there.

set -eu

input=$(cat)
name=$(printf '%s' "$input" | jq -r .name)
cwd=$(printf '%s' "$input" | jq -r .cwd)

case "$name" in
	'' | *[!A-Za-z0-9._-]* | .*)
		echo "worktree-create: refusing unsafe worktree name '$name'" >&2
		exit 1
		;;
esac

common_dir=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir)
root=$(dirname "$common_dir")
dir="$root/.claude/worktrees/$name"

git -C "$cwd" worktree add --detach "$dir" HEAD >&2
wt -C "$dir" step copy-ignored >&2 || echo "worktree-create: copy-ignored failed; continuing without cached deps" >&2

echo "$dir"
