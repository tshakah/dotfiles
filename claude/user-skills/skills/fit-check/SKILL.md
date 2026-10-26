---
name: fit-check
description: Checks whether a diff fits the wider codebase and hasn't overcomplicated the solution — duplicated abstractions, broken conventions, scope creep, missed consequences elsewhere, code that could be simpler or deleted. Takes a ticket ID or task description as args. Invoked by better-tdd, or on request before a commit or PR.
---

# Fit Check

## Purpose

A fit-check asks two things. Does the change fit the *wider* codebase: duplicated abstractions, broken conventions, scope creep, and consequences elsewhere that the change should have triggered but didn't. And is the change as simple as it can be: code that isn't needed, that a built-in already does, or that overcomplicates the solution. It is not a review of style or naming; that is the formatter's and the author's job.

The second question is the independent half of the refactor step. The author reviewing their own code believes it's fine and reliably under-deletes, so fit-check is where overcomplication and missed refactorings get caught. The preference order is: code that isn't written is best; code that can be removed is second; code that is kept because it's needed is third, and only if it doesn't overcomplicate the solution.

It must be done by a fresh agent with no context of writing the change. Whoever wrote it already believes it's fine — that's not a useful signal. The working AI must not perform its own fit-check.

## Input: what was intended

Supplied via `args`:

- **A ticket ID** (e.g. `DVC-5650`, `#1234`) — resolve it against whichever issue tracker is actually configured: Jira via the Atlassian MCP tools if authenticated, `gh issue view` / `gh pr view` for GitHub, etc. Don't assume Jira — check what's available first. If nothing resolves it (no tracker configured, ID not found), say so and ask for a manual description rather than guessing at what the ticket says.
- **A manual task description** — used as-is when there's no ticket, or when args is already free text rather than an ID-shaped string.

When invoked from within `better-tdd`, args is the specific test/behaviour just implemented in that cycle, not a ticket — treat it as a manual description. A cycle's own description cannot show that the behaviour should exist, so before a PR run one fit-check over the whole branch with the ticket ID as args.

## Scope: what diff to check

- If there are uncommitted changes (`git status --porcelain` is non-empty), check those: `git diff HEAD`.
- Otherwise, check the whole branch: diff against `git merge-base <default-branch> HEAD`.

State which scope was used before handing off to the review agent, so the result isn't a surprise about what got covered.

## Process

**If `rain` is configured:** run `rain cycle fit-check`. Rain spawns an independent `claude -p` process with the diff and task description, validates its output, and saves it. Do not write the fit-check artifact yourself.

**If `rain` is not configured:** spawn a separate agent with this brief:

> You are doing a fit-check on a change. Your job is to find mismatches between this change and the wider codebase, and to find what in the change is more complicated than it needs to be. Code that isn't written is the best code; code that can be removed is second best; code kept because it is needed is third, and only if it doesn't overcomplicate the solution. Do not style-review or rename things.
>
> Assume there is a mismatch to find, and assume the author left in code that didn't need to be there. Your default posture is adversarial, not approving: the author already believes this change is fine, so your job only has value if you actively try to prove them wrong before agreeing with them. Do not soften findings, hedge with "minor" or "nitpick" language to avoid friction, or lead with praise. If you catch yourself inclined to wave something through, treat that as a reason to look harder at it, not a reason to stop.
>
> **What was intended:** [resolved ticket content, or the manual description]
>
> Run `[the git diff command from the Scope step above]` to see what changed, then explore the codebase as needed.
>
> Look for:
> 1. Changes outside the intended scope (unrelated files modified, existing tests changed to accommodate rather than passing naturally)
> 2. Abstractions that duplicate something that already exists elsewhere in the codebase
> 3. Naming or structural patterns that conflict with established conventions
> 4. Consequences: anything in the wider codebase that should change because of this — an interface that now needs updating, a related module that has inconsistent behaviour
> 5. Simplification: for each function, field, clause and test case in the diff, ask what breaks if it is deleted and which behaviour in the task requires it. Look for: redundant checks (a second or third way of verifying the same thing); validation or branches nothing downstream depends on; speculative fields, options or parameters; hand-rolled versions of something the standard library or an existing module already does; tests that pin implementation detail (file layout, line counts, exact escaping) instead of behaviour, or that duplicate another test's coverage; and a pile of edge-case tests with no matching behaviour in the task. Propose the concrete smaller code, or name the specific cases to delete. Also ask what requirement needs the behaviour itself, not just what the code does: machinery whose only user is a fixture the tests invented, or a chain of checks that exists to support a feature that is not in the codebase yet, is a deletion candidate even when every piece is internally consistent. Prefer findings that remove code over findings that add it. Every proposed deletion, whether code, a test, config or anything else, must say what it would lose: the behaviour, or for a redundant test or config, what it duplicates or what depends on it. If it loses nothing, say so, and say how you checked (what still covers the behaviour, what references it).
>
> For each finding, say whether it is:
> - **Amend** — fixable now (small, local)
> - **Discuss** — requires a design decision or changes beyond this diff
>
> Only conclude there is nothing worth acting on after you can state, for each of the five categories above, specifically what you checked and why it came back clean — not a bare "looks fine." A category you didn't actually investigate doesn't count as clean.

## Handling findings

**Amend** findings: address only what was flagged — nothing more. Run tests. Run fit-check again.

**Discuss** findings: stop. Surface the finding to the human user — not the agent or orchestrator that invoked this skill — and wait for their direction before continuing. An intermediate agent must not decide on the user's behalf, even if it's the one that called fit-check.

**Recursion cap:** run at most three fit-checks total (initial + two amend cycles). If the third still finds Amend issues, surface them rather than continuing — repeated findings signal a deeper design problem that needs human judgment.

## Red flags — stop and reconsider

- The working AI reviewing its own change instead of spawning an independent agent
- Assuming a specific issue tracker (e.g. defaulting to Jira) without checking what's actually configured
- Guessing at ticket content when it can't be resolved, instead of asking for a manual description
- Treating "no findings" as the default and skipping the review to get there
- The review agent being agreeable or complimentary about the change instead of actively trying to find what's wrong with it
- Accepting "looks fine" without the agent stating what it checked in each of the five look-for categories
- A fit-check that only asks for more tests, more validation or better names, and proposes no deletions
- Amending a finding by adding code or test cases without first asking whether the thing could be removed instead
- Continuing past a Discuss finding without checking in with the human user (an orchestrating agent resolving it alone doesn't count)
- More than three fit-check cycles on one change without escalating to the user
