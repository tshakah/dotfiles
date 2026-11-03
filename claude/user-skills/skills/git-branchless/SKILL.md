---
name: git-branchless
description: Use for any history-changing or stack-navigating git work in a repo where git-branchless is initialised — fixing up an earlier commit on a topic branch, restacking, publishing a stack, or using worktrees. Encodes the amend-then-restack workflow and the worktree rules that avoid phantom staged changes.
---

# git-branchless

Work on commits, not branches. Fix up history by amending the commit that owns the change, then let `git restack` re-apply everything above it. Never write a script to do this.

Applies where `git branchless` has been initialised (`git sl` works). If it hasn't been, say so and ask before running `git branchless init`.

## Fixing up an earlier commit

1. Find the commit that introduced the code being fixed: `git blame` or `git log --follow -- <file>`. It is not necessarily the last commit.
2. `git checkout <sha>` (detached HEAD).
3. Stage the fix, then `git commit --amend`.
4. `git restack` re-applies the descendant commits and moves the branches on them.
5. Check the branch back out and confirm with `git sl`.

Never `git commit --fixup` with `rebase --autosquash`, and never create merge commits. Immediately after a failed pre-commit hook the amend did not happen, so commit fresh instead of amending.

`git restack` rebases in memory first and falls back to an on-disk rebase on conflict. Resolve the conflicts, then `git rebase --continue`. `git undo` returns to an earlier repository state if a rewrite went wrong.

## Navigating

- `git sl` shows the stack; `git next` and `git prev` move along it.
- `git move` reparents a subtree of commits; `git sync` moves local stacks onto the updated main branch.
- `git hide` and `git unhide` drop commits from the smartlog or bring them back.

## Publishing

`git submit` pushes the stack, so run it only when asked. `git submit -n` reports what it would push without pushing. Commits with no remote branch yet are pushed only with `--create`.

## Worktrees

`git restack` moves a branch even when it is checked out in another worktree, leaving that worktree's index and files at the old commit. The worktree then shows staged changes nobody made, such as `M  a` for a file the rewrite touched.

- Keep the main checkout on `main`.
- Create linked worktrees detached: `git worktree add --detach <path> <commit>`. A detached HEAD has no branch for a rewrite to move. A stack of any size can live in one worktree or several this way.
- Never have the same branch checked out in two worktrees.
- Worktrees are cheap, so create and remove them often. Remove with `git worktree remove`, without `--force`; git already refuses when files are modified or untracked.

If a worktree on a branch shows unexplained staged changes after a rewrite, check `git diff --cached`. If it is the reverse of the rewritten commit's changes and the worktree holds no work of its own, `git reset --hard HEAD` repairs it. If real edits are mixed in, stop and ask before resetting anything.
