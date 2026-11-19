# Global Guidelines

## Git

Never create merge commits. Use fast-forward merges or rebases only (`--ff-only` or `--rebase`). If a fast-forward is not possible, rebase first, then merge.

Prefer amending over creating new commits when fixing up work on non-trunk (feature/topic) branches. Amend the commit that introduced the code being fixed, not necessarily the last one: find it with `git log --follow -- <file>` or `git blame`, then `git checkout <sha>`, stage the fix, `git commit --amend`, `git restack` (git-branchless) to re-apply the descendant commits, and check the branch back out. Never use fixup commits with `rebase --autosquash`. This overrides Claude Code's default "always create new commits" protocol, except immediately after a failed pre-commit hook — there, the commit didn't actually happen, so amending would silently rewrite the previous commit instead; fix the issue and commit fresh in that specific case.

In a git-branchless repo, work on PR branches from a worktree and follow this routine:

1. Before starting, run `git sync --pull` so the stack is current with the remote. It restacks the whole repo, so run it at the start of a task, not in the middle of the user's own rebase.
2. After finishing, run `git restack`, then `git submit`, with no extra arguments. The only exception is `git restack --merge` when there are conflicts, which you resolve yourself.

Never pass a revset or flags to `git submit`, except `--create` for a branch that has never been pushed, and never substitute `git push` for it. If `git restack` does not move a stack, or `git submit` skips a branch, you broke git state: look for two branches on one commit, a branch checked out in another worktree, or a stray temporary branch, remove the cause, and run the plain commands again. Don't leave temporary fix branches next to the PR branch; move the real branch with `git branch -f` or amend in place. Afterwards verify every local branch equals its `origin/` counterpart and report what moved.

## Task Tracking

Never use Claude Code's internal todo/task tracking. Use the Vikunja MCP for all task creation and tracking instead.

## Planning

When writing implementation plans, use the `better-plans` skill, not `writing-plans`. When implementing features or bugfixes, use the `better-tdd` skill, not `test-driven-development`. Plans must describe observable behaviours and outcomes — not implementation code.

## Code and Comments

Never reference previous behaviour, old implementations, or prior code in comments, test names, or test descriptions. Git is the historical record. Comments and tests describe only what the code does now, and even then only if the code isn't self-describing.

This also rules out phrasing that implies a change without naming one explicitly — e.g. "no longer needs a wrapper", "now resolves directly", "instead of doing X". Before writing a comment, check whether it would still make sense to someone who never saw the old version; if not, rewrite it to state only the current behaviour.

Comments explain *why*, not *what*, and only when the *why* isn't already obvious from the code (a non-obvious constraint, a subtle invariant, a workaround). If a comment would just restate what well-named code already shows, delete it rather than rephrase it.

## Communication

When the user writes "!?", treat it as an invitation for adversarial engagement, not just polite pushback. Assume there is a flaw or weakness to find and actively look for it before agreeing — don't lead with praise, don't soften findings to cushion them, and don't settle for "looks fine" without being able to say specifically what was checked and ruled out. Don't agree just because the idea is stated softly. Use direct agreement only when they use direct language.
