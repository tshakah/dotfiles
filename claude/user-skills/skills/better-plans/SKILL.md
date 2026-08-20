---
name: better-plans
description: Use when you have a spec or requirements for a multi-step task and need to write an implementation plan. Produces behaviour-driven plans — observable outcomes and test assertions, no implementation code. Use this instead of writing-plans whenever planning a feature, bugfix, or refactor.
---

# Writing Implementation Plans

## The Core Rule

**Plans describe what must be true after implementation. They do not describe how to implement it.**

If you find yourself writing code — even pseudocode, even "something like" code — stop. That decision belongs to the implementing agent, who will discover the right shape through TDD. A plan that pre-writes the implementation bypasses the design feedback that TDD is meant to provide.

## Output: write the plan to a file, don't print it

The finished plan is a deliverable the user will hand to an implementing agent later — it must survive after this turn ends, so it does not belong solely in chat scrollback.

- Plans live outside the project entirely, in the `~/shared/notes/zk` zk notebook (synced by Syncthing) — never under the project's own `.claude/plans/` or anywhere inside its git repo.
- Derive the org folder from the project's path: the path segment immediately after `source/` (e.g. `~/source/doccla/opentele` → org `doccla`; on another machine, `~/source/sadzaco/whatever` → org `sadzaco`). If the project isn't under a `source/` directory, fall back to the repo's top-level folder name as the org.
- Write the plan with the Write tool to `~/shared/notes/zk/plans/<org>/<repo>/<slug>.md`, where `<repo>` is the project repo's directory name and `<slug>` is a short descriptive kebab-case name (e.g. `~/shared/notes/zk/plans/doccla/opentele/patient-order-by-dispatch.md`). Create the `plans/<org>/<repo>/` directory if it doesn't exist yet.
- Give the file zk frontmatter so it's queryable with `zk list --tag`:
  ```
  ---
  title: <human-readable title>
  date: <today, YYYY-MM-DD>
  tags: [plan, <org>, <repo>]
  status: draft
  ---
  ```
- Do not also paste the full plan into your chat response. Reply with the file path and a one-or-two-sentence summary of what the plan covers (task count, what's parallelisable) — enough for the user to decide whether to open it.
- If you're revising a plan already written this session, edit that same file rather than creating a new one, unless the user asks for a distinct alternative plan.
- This applies whether the plan was requested standalone or via `EnterPlanMode` — the file is the artifact; anything shown on screen is just a pointer to it.

## Why This Matters

When a plan includes implementation code, the agent transcribes rather than designs. The failing test can't push back on a bad abstraction because the abstraction is already decided. Refactor has nothing to discover because the structure arrived pre-formed. The whole point of TDD — letting the tests reveal the right design — is lost.

## What a Plan Contains

### Per-task structure

```
## Task N: [name]

**Files:** [files that will be touched, with a one-line reason why each one]

**Fit note:** [does this imply changes to existing abstractions? name them, or write "none"]

**Behaviours:**
- Given [setup], when [action], [observable outcome]
- Given [setup], when [action], [observable outcome]

**Edge cases:**
- [stated as a behaviour, not as code]
```

### Behaviours are assertions, not instructions

Each behaviour should read like a test description: a condition, an action, and a verifiable result. The implementing agent will turn these directly into test cases.

Good: "Given a signal with category `danger`, when rendered at any bandwidth ratio, the fingerprint pattern differs from `resource` by more than 0.05 on average across columns."

Bad: "Use `CATEGORY_FINGERPRINT[cat]` with a clarity floor of `0.15` to keep the pattern visible."

The good version tells the agent what to verify. The bad version tells the agent what to write — removing the test's ability to inform the design.

### Fit notes

Before writing behaviours, consider: does implementing this touch an abstraction that already exists under a different name? Will it introduce a concept that should live somewhere else? Will it require a change to an interface that other code depends on?

Name these explicitly in the fit note. The fit-check agent that runs after implementation will know to look there.

### Files and scope

List the files to be touched and why — this is a scope boundary, not an implementation prescription. If the implementing agent discovers that the right design touches a different file, that discovery is valuable information. The fit-check will surface it.

## What a Plan Does Not Contain

- Implementation code of any kind
- Specific function signatures (unless you're specifying a public API contract)
- Algorithm choices
- Variable names
- "Something like `x = foo(y) * 0.15`"
- Step-by-step implementation instructions ("first do X, then do Y")

If you're describing the inside of a function, you've gone too far.

## Fit Concerns at Plan Time

Before finalising the plan, read the relevant parts of the codebase and ask:

- Does this feature belong in the proposed file, or does the codebase have an established pattern that suggests a different home?
- Is there an existing abstraction this should extend rather than duplicate?
- Does anything in scope suggest the wider design needs to change first?

If yes: flag it in the fit note, or raise it with the user before writing the plan. It is cheaper to resolve a design mismatch at plan time than after implementation.

## Parallelism

Tasks that don't share state can be parallelised across agents. Mark them explicitly:

```
[PARALLEL] Task 1 and Task 2 can run concurrently — they touch different modules.
[SEQUENTIAL] Task 3 depends on Task 2 completing first.
```

## The Executing Agent's Contract

The agent who executes this plan will, for each task:
1. **Invoke the `better-tdd` skill** via the Skill tool before writing any code — not summarise it, not recall it from memory, invoke it
2. Follow that skill exactly to write failing tests from the task's behaviours, implement minimally, and refactor
3. Commit
4. Run a fit-check via a separate agent to verify wider codebase alignment
5. Amend if the fit-check finds issues (up to two rounds)

**When writing the prompt for an implementing subagent**, do not paraphrase or inline the `better-tdd` skill. Tell the agent to invoke it: `"Before writing any code, invoke the better-tdd skill."` The agent has the Skill tool; use it.

Your plan is the input to step 1. Write it so the behaviours are clear enough to become test names and assertions directly.

## Red Flags in Your Own Plan

- You wrote a function body, even in comments
- You specified a data structure layout for something internal
- The "behaviour" section reads like a recipe ("call X, then Y, then Z")
- No fit note, but the task touches an abstraction that exists elsewhere
- The task description says "implement X using Y" rather than "after this, X must be true"
