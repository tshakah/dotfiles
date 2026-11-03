#!/bin/sh
# No --force: a worktree with uncommitted or untracked changes is kept and the hook fails.

set -eu

path=$(jq -r .worktree_path)
git -C "$path" worktree remove "$path"
