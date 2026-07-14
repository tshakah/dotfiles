---
name: better-tdd
description: Use when implementing any feature or bugfix, before writing implementation code. Extends red-green-refactor with a mandatory fit-check step that spawns an independent agent to scan the full diff for codebase-wide design mismatches before committing.
---

# Test-Driven Development

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

If you think this situation is an exception: **stop and ask**. Never decide unilaterally to skip tests.

## Exceptions — Ask First

Before skipping TDD, say why you think it qualifies and ask the user. Common legitimate exceptions:
- Throwaway prototypes / exploratory code (but ask — "exploratory" is often overclaimed)
- Configuration files
- Generated code

Do not use "exploratory" as a blanket escape hatch. If uncertain, ask.

## The Cycle — One Behaviour at a Time

Never batch. Complete RED → GREEN → REFACTOR → FIT-CHECK → COMMIT before writing the next test.

### RED — Write One Failing Test

Write the smallest test that describes one behaviour. Name it clearly.

Run it. Confirm it fails **for the right reason** — a missing function or wrong return value, not a compile error or typo. If it passes immediately, the test is wrong; fix it.

**Before moving to GREEN, apply the test quality gate:**

Does the test assert what the system *does*, or just that it *moved*?

- Redirect tests must be followed by content assertions verifying the destination
- Presence/membership checks must verify the value, not just existence
- "Function was called" checks must verify the result it produced
- "No error occurred" is not a meaningful assertion on its own

If the test only asserts surface signals, it is incomplete. Fix it before proceeding.

### GREEN — Minimal Code

Write the simplest code that makes the test pass. Nothing more.

- No extra features
- No edge cases the test doesn't cover
- No tidying, no generalising

Run the specific test. Then run all tests. If anything else breaks, fix it now.

### REFACTOR — Local Design

Refactor is where design happens. It is not optional.

Read the **full module or file**, not just the code just written. Look for:
- Duplication — in production code *and* in tests
- Functions doing too much
- Naming that doesn't reveal intent
- Patterns emerging across multiple functions that suggest an abstraction
- Private helpers worth extracting
- Structural fit within the module

Make targeted improvements. Run tests after each change — if they go red, undo and try a smaller step. Don't change behaviour.

You must document your findings either way. "No refactoring needed" requires a reason. A one-line dismissal is not acceptable.

### FIT-CHECK — Wider Codebase

The local refactor only sees the file you're in. Fit-check asks whether the implementation fits the broader codebase. It must be done by a **fresh agent with no context of writing the code** — the working AI must not perform its own fit-check.

**If `rain` is configured:** run `rain cycle fit-check`. Rain spawns an independent `claude -p` process with the diff and task description, validates its output, and saves it. Do not write fit-check.md yourself.

**If `rain` is not configured:** spawn a separate agent with this brief:

> You are doing a fit-check on uncommitted changes in a TDD cycle. Your job is not to improve the code — it is to find mismatches between the new code and the wider codebase.
>
> **What was intended:** [paste the task description or test/behavior being implemented]
>
> Run `git diff HEAD` to see what changed, then explore the codebase as needed.
>
> Look for:
> 1. Changes outside the intended scope (unrelated files modified, existing tests changed to accommodate rather than passing naturally)
> 2. Abstractions that duplicate something that already exists elsewhere in the codebase
> 3. Naming or structural patterns that conflict with established conventions
> 4. Consequences: anything in the wider codebase that should change because of this — an interface that now needs updating, a related module that has inconsistent behaviour
>
> For each finding, say whether it is:
> - **Amend** — fixable before commit (small, local)
> - **Discuss** — requires a design decision or changes beyond this commit
>
> If you find nothing worth acting on, say so clearly with a reason.

**If the fit-check returns findings:**

For **Amend** findings: address only what was flagged — nothing more. Run tests. Run a second fit-check.

For **Discuss** findings: stop. Present the finding to the user and ask how to proceed before continuing.

**Recursion cap:** Run at most three fit-checks total (initial + two amend cycles). If the third fit-check still finds Amend issues, surface them to the user rather than continuing — repeated findings signal a deeper design problem that needs human judgment.

### COMMIT — Lock In Green

**One commit per behaviour cycle.** The commit contains the failing test, the implementation that makes it pass, the local refactor, and any fit-check amendments — all together, all green, in a single atomic commit. This is the unit of history.

- Never commit at RED. Failing tests do not enter history as standalone commits.
- Never split GREEN and REFACTOR into separate commits.
- Fit-check amendments are fixed in the working tree before committing — the commit is already clean.

**If `rain` is configured:** run `rain cycle commit`. Rain runs the full suite, stages cycle artifacts, and commits.

**If `rain` is not configured:** commit manually with a message that describes the behaviour, not the process.

### Repeat

Do not write the next test until the fit-check is clean or any Discuss findings have been resolved with the user.

## Per-Project Overrides

Check CLAUDE.md for:
- Project-specific exceptions (e.g. exploratory harnesses, workbench code)
- Test commands and file conventions
- Language-specific patterns

Project CLAUDE.md takes precedence over this skill for context-specific rules.

## Parallel-Agent Operation

This skill assumes single-stream operation. If multiple agents are committing on the same branch, **the orchestrator owns coordination** — typically by carving non-overlapping work or serialising agents on overlapping work.

**Running in parallel does not authorise skipping any step.** RED, GREEN, REFACTOR, FIT-CHECK, and COMMIT are non-negotiable regardless of how the agent was dispatched.

## Red Flags — Stop and Reconsider

- Writing code before a test exists
- Test passes immediately without implementation
- Can't explain why the test failed
- Refactor step skipped or dismissed without justification
- Fit-check skipped or dismissed without running it
- Working AI writing its own fit-check artifact (self-reporting defeats the purpose)
- Test only asserts surface signals (redirect happened, element present, function called)
- Deciding to skip tests without asking
- Committing before fit-check is clean
- Committing at RED, or splitting one cycle's test/implementation/refactor into separate commits
