---
name: comment-check
disable-model-invocation: true
description: Reviews comments added or changed in a diff against the "why, not what" rule — restating what the code shows, referencing prior behaviour, or over-explaining. Use alongside commit-check before a PR.
---

# Comment Check

## Purpose

Comments are easy to over-write: an explanation that felt necessary while writing the code often turns out to just restate what the code already shows once someone else reads it cold. This skill checks comments added or changed in a diff against a specific, fixed rule — it is not a general code-quality review and not a fit-check concern (no wider-codebase exploration needed).

The rule being checked (from the global CLAUDE.md):

> Comments explain *why*, not *what*, and only when the *why* isn't already obvious from the code. Never reference previous behaviour, old implementations, or prior code — git is the historical record. This also rules out phrasing that implies a change without naming one (e.g. "no longer needs...", "now resolves...", "instead of doing X"). If a comment would just restate what well-named code already shows, delete it rather than rephrase it.

It must be done by a fresh agent with no context of writing the diff. Whoever wrote a comment already believed it was needed at the time — that's not a useful signal on its own.

## Scope: what diff to check

- If there are uncommitted changes (`git status --porcelain` is non-empty), check those: `git diff HEAD`.
- Otherwise, check the whole branch: diff against `git merge-base <default-branch> HEAD`.

Only comment lines that are added or modified by the diff are in scope — pre-existing comments the change didn't touch are not this skill's concern.

State which scope was used before handing off to the review agent.

## Process

Spawn a separate agent with this brief:

> You are checking comments added or changed in a diff against a specific rule. Your job is not to review the code's correctness or design — only the comments.
>
> Run `[the git diff command from the Scope step above]`. For every comment line the diff adds or modifies, judge it against this rule:
>
> [paste the rule text above]
>
> Assume each comment fails the rule until you've specifically checked it against every clause. The author already believed each comment was warranted when they wrote it, so approving without friction adds nothing — actively look for restatement, historical references, and implied-change phrasing before concluding a comment is clean.
>
> For each comment, check:
> 1. **Restatement** — does it just say what the following line(s) already show, given reasonably clear naming?
> 2. **Historical reference** — does it mention prior behaviour, an old implementation, a removed code path, or a past issue/ticket, rather than describing only the current state?
> 3. **Implied change without naming one** — phrasing like "no longer needs...", "now does X instead of Y", "simplified from..." that only makes sense to someone who saw the old version?
> 4. **Genuine why** — if none of the above apply, does the comment actually explain a non-obvious constraint, invariant, or workaround — or is it explaining something obvious dressed up as a "why"?
>
> For each finding, say whether it is:
> - **Amend** — delete the comment, or rewrite it to state only the current behaviour's non-obvious "why"
> - **Discuss** — the comment is defensible but borderline (e.g. genuinely unclear whether the invariant it names counts as "obvious"); needs a human call
>
> Only conclude a comment is clean after stating what you checked against each of the four points — not a bare "looks fine."

## Handling findings

**Amend** findings: fix directly — delete the comment or rewrite it per the rule. Re-run comment-check to confirm.

**Discuss** findings: surface to the human user, not an orchestrating agent, and wait for direction.

**Recursion cap:** run at most three times total (initial + two amend cycles). If Amend findings remain at the cap, surface them rather than continuing.

## Red flags — stop and reconsider

- The working AI reviewing its own comments instead of spawning an independent agent
- Folding this into fit-check — fit-check is explicitly not a code-quality review; this is
- Treating "no findings" as the default and skipping the review to get there
- Accepting "looks fine" without the agent stating what it checked against each of the four points
- Fixing a Discuss finding without checking in with the human user first
- Reviewing comments the diff didn't touch — out of scope, not this skill's job
