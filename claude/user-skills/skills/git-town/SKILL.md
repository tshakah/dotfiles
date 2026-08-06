---
name: git-town
description: Use for feature-branch workflows (create, sync, propose, ship, stacked branches) in any repo where git-town is installed. Prefers git-town's commands over raw git for branch creation, sync, and merge/delete, since raw git commands silently break git-town's branch-lineage tracking. Confirmation-gates the commands that rewrite history, touch shared state, or are hard to reverse — no blanket hook blocking raw git, since that would conflict with commit-check's use of `git rebase -i` for message rewording.
---

# Git Town

## Prerequisites

Before running any git-town command in a repo, confirm:

- `git-town` is installed and on `PATH`.
- The repo has a main branch configured (`git-town config` shows it under "Branches"). If unset, this is first-time setup for the repo — confirm with the user before running `git-town init` (or setting it directly) rather than guessing which branch is main.

## When to use

Any repo where feature branches get created, synced with main, and merged or shipped. Use git-town's commands instead of the raw-git equivalents for those operations, because git-town tracks parent/child branch relationships that raw git commands don't know about and will silently break:

| Operation | Use | Not |
|---|---|---|
| Create a feature branch | `git-town hack <branch>` | `git checkout -b` |
| Stack a branch on the current one | `git-town append <branch>` / `git-town prepend <branch>` | manual branch + manual parent tracking |
| Update from main/parent | `git-town sync` | `git pull`, `git merge <parent>` |
| Open a PR | `git-town propose` | manual `gh pr create` (git-town pre-populates it against the right parent) |
| Merge and clean up | `git-town ship` | `git merge` + `git branch -d` |
| Remove a branch | `git-town delete [<branch>]` | `git branch -d`/`-D` |

Raw git stays fine for everything git-town doesn't touch: `add`, `commit`, `status`, `log`, `diff`, `stash`.

**`commit-check`'s `git rebase -i <base>` reword step is not replaceable by git-town** — `compress` only squashes *all* commits on a branch into one, and `sync` never touches an individual commit's message. Keep using raw `git rebase -i` for that specific job; don't try to route it through git-town.

## Command reference

Verified against `git-town help <command>` directly — do not trust command syntax from memory or from a search result without checking it here first, since online write-ups for git-town get its flags wrong (e.g. claiming `hack` takes `--parent`, which it does not).

**Creating branches — no confirmation needed beyond the branch name itself:**
- `git-town hack <branch>` — new feature branch off **main only**. There is no `--parent` flag; you cannot hack a branch off an arbitrary parent.
- `git-town append <branch>` — new child branch of the *current* branch (stack on top of where you are).
- `git-town prepend <branch>` — new branch inserted as the parent of the current branch.

**Everyday sync/navigation — no confirmation needed:**
- `git-town sync` — updates the current branch from its parent (or main) and pushes it. Under the `rebase` strategy (dotfiles sets this globally), that push is a safe force-push (`--force-with-lease --force-if-includes`) — that's why it doesn't need the confirmation other force-pushes get.
- `git-town switch` / `git-town up` / `git-town down` — branch navigation.
- `git-town continue` — resume after resolving a conflict.
- `git-town undo` — undoes the most recent git-town command. This exists as a recovery option — mention it if something just went wrong, don't wait to be asked.

**Confirm before running — destructive, history-rewriting, or visible to others:**
- `git-town propose` — opens/creates a PR. Confirm title/body first, same as any PR creation.
- `git-town ship [--to-parent]` — merges the branch into its parent and deletes it. Only ships direct children of main by default; a deeper stack needs `--to-parent` or shipping/deleting ancestors first. Confirm which branch and which mode before running.
- `git-town delete [<branch>]` — deletes a branch and its tracking branch. Confirm which branch.
- `git-town compress [--stack]` — squashes all commits on the branch (or the whole stack) into one, rewriting history. Confirm, and call out the force-push implication if the branch is already pushed — same reasoning as `commit-check`'s handling of history rewrites.

## Red flags — stop and reconsider

- Using `git checkout -b`, raw `git merge`, or `git branch -d` on a git-town-managed repo instead of `hack`/`sync`/`delete` — breaks git-town's branch lineage tracking without any error
- Running `ship`, `delete`, `compress`, or `propose` without confirming first
- Assuming `hack` supports a `--parent` flag — it doesn't; use `append`/`prepend` for stacking
- Treating `compress` or `sync` as a substitute for `commit-check`'s single-commit reword step — neither does that
- Installing a hook that blanket-blocks raw git commands (e.g. blocking all `git rebase`) instead of confirming per action — that would also block `commit-check`'s legitimate use of `git rebase -i`
