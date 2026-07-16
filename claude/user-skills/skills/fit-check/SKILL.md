---
name: fit-check
description: Use to check whether a diff fits the wider codebase — not whether it's well-written internally, but whether it duplicates an existing abstraction, breaks convention, drifts outside its intended scope, or leaves something else in the codebase inconsistent. Spawns an independent agent with no authorship context, since whoever wrote the change already believes it's fine. Takes a ticket ID or a manual task description as args describing what was intended; resolves ticket IDs against whatever issue tracker is configured, or accepts free text directly. Used standalone before a commit/PR, or as the FIT-CHECK step inside better-tdd.
---

# Fit Check

## Purpose

A fit-check asks whether a change fits the *wider* codebase. It is not a code-quality review of the change itself — that's local refactoring, done by whoever wrote the code. Fit-check is specifically about mismatches with everything the change doesn't touch: duplicated abstractions, broken conventions, scope creep, and consequences elsewhere that the change should have triggered but didn't.

It must be done by a fresh agent with no context of writing the change. Whoever wrote it already believes it's fine — that's not a useful signal. The working AI must not perform its own fit-check.

## Input: what was intended

Supplied via `args`:

- **A ticket ID** (e.g. `DVC-5650`, `#1234`) — resolve it against whichever issue tracker is actually configured: Jira via the Atlassian MCP tools if authenticated, `gh issue view` / `gh pr view` for GitHub, etc. Don't assume Jira — check what's available first. If nothing resolves it (no tracker configured, ID not found), say so and ask for a manual description rather than guessing at what the ticket says.
- **A manual task description** — used as-is when there's no ticket, or when args is already free text rather than an ID-shaped string.

When invoked from within `better-tdd`, args is the specific test/behaviour just implemented in that cycle, not a ticket — treat it as a manual description.

## Scope: what diff to check

- If there are uncommitted changes (`git status --porcelain` is non-empty), check those: `git diff HEAD`.
- Otherwise, check the whole branch: diff against `git merge-base <default-branch> HEAD`.

State which scope was used before handing off to the review agent, so the result isn't a surprise about what got covered.

## Process

**If `rain` is configured:** run `rain cycle fit-check`. Rain spawns an independent `claude -p` process with the diff and task description, validates its output, and saves it. Do not write the fit-check artifact yourself.

**If `rain` is not configured:** spawn a separate agent with this brief:

> You are doing a fit-check on a change. Your job is not to improve the code — it is to find mismatches between this change and the wider codebase.
>
> Assume there is a mismatch to find. Your default posture is adversarial, not approving: the author already believes this change is fine, so your job only has value if you actively try to prove them wrong before agreeing with them. Do not soften findings, hedge with "minor" or "nitpick" language to avoid friction, or lead with praise. If you catch yourself inclined to wave something through, treat that as a reason to look harder at it, not a reason to stop.
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
>
> For each finding, say whether it is:
> - **Amend** — fixable now (small, local)
> - **Discuss** — requires a design decision or changes beyond this diff
>
> Only conclude there is nothing worth acting on after you can state, for each of the four categories above, specifically what you checked and why it came back clean — not a bare "looks fine." A category you didn't actually investigate doesn't count as clean.

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
- Accepting "looks fine" without the agent stating what it checked in each of the four look-for categories
- Continuing past a Discuss finding without checking in with the human user (an orchestrating agent resolving it alone doesn't count)
- More than three fit-check cycles on one change without escalating to the user
