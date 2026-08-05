---
name: commit-check
description: Use before opening a PR or merging a branch to review its full commit history. Checks that each commit's message explains why (not just what) and captures any decision a future `git blame` reader would need, and that commits are atomic and correctly ordered. Spawns an independent agent with no authorship context to judge the messages/diffs, since the author already knows the reasoning and can't judge whether it reads clearly to a stranger. Can offer to fix findings via rebase, with per-action confirmation.
---

# Commit Check

## When to use

- Before opening a PR
- Before merging a branch
- Any time you've made a string of commits and want to sanity-check the resulting history

Checks commit messages only. For comments left in the code itself, run `comment-check` alongside this before a PR.

## What it checks

Four things, per commit and across the branch as a whole:

1. **Explains why** — the message states the reasoning, not just a restatement of the diff. Any non-obvious decision, trade-off, or workaround a future `git blame` reader would need is called out.
2. **Accurate** — the message's description of what changed matches what the diff actually does. No claim in the message left unsupported by the diff, no diff content the message doesn't mention.
3. **Atomic** — each commit is one coherent logical change. No unrelated changes bundled together, no "and also fixed a typo" riders that belong in their own commit.
4. **Ordered** — commits form a sensible, bisectable sequence: dependencies before dependents, no later commit that should have been folded into an earlier one.

## Process

### 1. Determine the range

Find the branch's base with `git merge-base <default-branch> HEAD`. Detect the default branch (`git remote show origin`, or the repo's own convention); if genuinely ambiguous, ask the user which ref to diff against rather than guessing.

List the commits: `git log <base>..HEAD --oneline`.

### 2. Spawn an independent review agent

Same rationale as `better-tdd`'s fit-check: whoever wrote the commits already knows why they made each decision, so they cannot judge whether the message actually communicates it to someone who wasn't there. A fresh agent with no memory of authoring the change must do the review — the working AI must not review its own commits.

Give the agent:
- The commit list, and for each commit `git show <sha>` (message + diff)
- No other context about the task/ticket beyond what's in the messages themselves — if a message only makes sense with a ticket number the agent wasn't given, that's itself a finding

Brief:

> Review commits `<base>..HEAD` on this branch. You did not write this code — judge it as a future teammate running `git blame` would, with no other context.
>
> Assume each commit has a flaw in at least one of the four checks below until you've specifically ruled it out. The author already believes their own history is fine, so approving it without friction adds nothing — your value is in actively trying to find the message that doesn't hold up, the message that misdescribes its own diff, the commit that bundles two changes, or the ordering that doesn't bisect cleanly. Don't soften findings or lead with praise to cushion them.
>
> For each commit, check:
> 1. **Why, not what** — does the message explain the reasoning, or just restate the diff? Flag any non-obvious decision, trade-off, workaround, or constraint visible in the diff that the message doesn't mention.
> 2. **Accuracy** — does the message's description of what changed match what the diff actually does? Flag any claim in the message not borne out by the diff, and any diff content the message doesn't mention.
> 3. **Atomicity** — does the diff contain more than one logical change? Flag unrelated files or concerns bundled into one commit.
> 4. **Ordering** — read the commits in sequence. Flag any commit that fixes, reverts, or reworks something from an earlier commit in a way that should have been folded into it instead. Flag any commit that only makes sense once a later commit lands.
>
> For each finding, classify it:
> - **Amend** — message-only fix (reword), no code/structural change needed
> - **Discuss** — needs commits split, squashed, or reordered — a structural rebase decision
>
> Don't invent findings to fill space, but a commit only counts as clean once you state what you specifically checked for each of the four points above and why it held up — not a bare "looks fine."

### 3. Handle findings

**Amend findings** (message rewording): offer to fix via `git rebase -i <base>` with `reword`, one commit at a time. Draft the new message and confirm the exact wording with the user before writing it — don't silently rewrite someone's commit message.

**Discuss findings** (split/squash/reorder): present the finding and a concrete rebase plan (which commits, what new order, what gets squashed, which hunks move where for a split) and get explicit confirmation before running anything. Never guess at a split — show the proposed hunk division first.

**Before touching history at all:**
- Check whether the branch is pushed and tracked (`git rev-parse --abbrev-ref @{u}`). If it has an upstream, rewriting requires a force-push afterward — say so explicitly and get confirmation for the force-push separately from the confirmation for the rebase itself.
- Never rewrite a commit authored by someone else (compare `git log --format='%an'` against the current git user) without flagging it first.
- Never run this against `main`/`master` or any shared/protected branch directly — only feature branches.
- Follow the global git rule: no merge commits: rebase, not merge, when incorporating upstream changes during this process.

**Recursion cap:** after applying fixes, run the review once more to confirm it's clean. Cap at two fix cycles total — if issues remain after that, stop and hand the remaining findings to the user rather than continuing to rebase.

## Red flags — stop and reconsider

- Reviewing your own commits yourself instead of spawning an independent agent
- The review agent being agreeable or complimentary about the commits instead of actively trying to find what's wrong with them
- Accepting "looks fine" on a commit without the agent stating what it specifically checked for each of the four points
- Rewriting a message without confirming the new wording with the user first
- Rebasing or force-pushing without a separate, explicit confirmation for each
- Rewriting commits already pushed without calling out the force-push implication
- Splitting a commit by guessing rather than showing the proposed hunk split first
- Treating "ordered" as just chronological — the check is whether the sequence is *logical* (bisectable, dependencies before dependents), not merely the order they happened to be written in
