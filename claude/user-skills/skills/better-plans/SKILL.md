---
name: better-plans
description: Use when you have a spec or requirements for a multi-step task and need to write an implementation plan. Produces behaviour-driven plans — observable outcomes and test assertions, no implementation code. Use this instead of writing-plans whenever planning a feature, bugfix, or refactor.
---

# Writing Implementation Plans

## Step 1: Stress-test the domain before drafting tasks

Before writing a task, call Skill tool twice, for `domain-modeling` and `grilling`, to stress-test spec's terminology and edge cases. Resolve terminology conflicts and genuine edge cases here, at terminology/requirements level — not later, inside a task's Edge cases field, where only requirement-reachable cases belong (see "What a Plan Contains" below).

## The Core Rule

**Plans describe what must be true after implementation. They do not describe how to implement it.**

If you write code — even pseudocode, even "something like" code — stop. That decision belongs to the implementing agent, who will discover the right shape through TDD. A plan that pre-writes implementation skips the design feedback TDD is meant to give.

## Stance: KISS, YAGNI, POLA

Hold these three while planning. Every task and behaviour must be needed today: by a requirement, an acceptance criterion, or existing code. A consequence chain ("this needs X, which needs Y, which needs a check on Y") is followed only as far as the requirement at its head is real. If the head is a feature that doesn't exist yet, the chain is not planned. A smaller plan is better, as long as it still meets every criterion.

## Output: write the plan to a file, don't print it

The finished plan is a deliverable the user hands to an implementing agent later — it must survive after this turn ends, so it doesn't belong solely in chat scrollback.

- Plans live outside the project entirely, in the `~/shared/notes/zk` zk notebook (synced by Syncthing) — never under the project's own `.claude/plans/` or anywhere in its git repo.
- Derive the org folder from the project's path: the segment right after `source/` (e.g. `~/source/doccla/opentele` → org `doccla`; on another machine, `~/source/sadzaco/whatever` → org `sadzaco`). If the project isn't under a `source/` directory, fall back to the repo's top-level folder name as org.
- Write the plan with the Write tool to `~/shared/notes/zk/plans/<org>/<repo>/<slug>.md`, where `<repo>` is the project repo's directory name and `<slug>` is a short kebab-case name (e.g. `~/shared/notes/zk/plans/doccla/opentele/patient-order-by-dispatch.md`). Create the `plans/<org>/<repo>/` directory if it doesn't exist yet.
- Give the file zk frontmatter so it's queryable with `zk list --tag`:
  ```
  ---
  title: <human-readable title>
  date: <today, YYYY-MM-DD>
  tags: [plan, <org>, <repo>]
  status: draft
  ---
  ```
- Don't also paste the full plan into chat. Reply with the file path and a one-or-two-sentence summary of what the plan covers (task count, ordering) — enough for the user to decide whether to open it.
- If you're revising a plan already written this session, edit that file rather than make a new one, unless the user asks for a distinct alternative plan.
- This applies whether the plan was requested standalone or via `EnterPlanMode` — the file is the artifact; anything shown on screen is just a pointer to it.

## What a Plan Contains

### Per-task structure

```
## Task N: [name]

**Files:** [files that will be touched, with a one-line reason why each one]

**Needed now:** [the requirement, acceptance criterion or existing caller that needs this task today. "A future X might need it" does not count; with no answer, cut the task]

**Fit note:** [does this imply changes to existing abstractions? name them, or write "none"]

**Behaviours:**
- Given [setup], when [action], [observable outcome]
- Given [setup], when [action], [observable outcome]

**Edge cases:**
- [stated as a behaviour, not as code; only those a requirement or a real caller makes reachable]
```

End the plan with a **Non-goals** list: things a thorough plan might include that this one leaves out on purpose, each with the reason (no current requirement, no caller yet).

### Behaviours are assertions, not instructions

Each behaviour should read like a test description: a condition, an action, a verifiable result. The implementing agent turns these directly into test cases.

Good: "Given a signal with category `danger`, when rendered at any bandwidth ratio, the fingerprint pattern differs from `resource` by more than 0.05 on average across columns."

Bad: "Use `CATEGORY_FINGERPRINT[cat]` with a clarity floor of `0.15` to keep the pattern visible."

The good version tells the agent what to verify. The bad version tells the agent what to write — removing the test's ability to inform the design.

### Fit notes

Before writing behaviours, ask: does this touch an abstraction that already exists under a different name? Does it introduce a concept that should live elsewhere? Does it require a change to an interface other code depends on?

Name these explicitly in the fit note. The fit-check agent that runs after implementation will know to look there.

Also name the single highest seam this plan tests through: prefer an existing seam over a new one, and the highest-level one available. Fewer seams across the plan is better — one is ideal. A plan testing through five internal checkpoints is harder to keep passing across a refactor than one testing through the one public entry point that already covers them all.

### Files and scope

List the files to be touched and why — a scope boundary, not an implementation prescription. If the implementing agent finds the right design touches a different file, that's valuable information the fit-check will surface.

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

- Does this feature belong in the proposed file, or does the codebase have an established pattern suggesting a different home?
- Is there an existing abstraction this should extend rather than duplicate?
- Does anything in scope suggest the wider design needs to change first?

If yes: flag it in the fit note, or raise it with the user before writing the plan. It's cheaper to resolve a design mismatch at plan time than after implementation.

## Strangler-fig refactors

A **strangler-fig refactor** is the exception to vertical slicing: one mechanical change (rename a shared column, retype a symbol every caller imports) whose blast radius breaks every caller at once, so no single task can land green alone. Forcing it into the per-task template above makes a task that's permanently red until every caller everywhere updates in the same commit — don't do that. Sequence it in three stages instead, each its own task:

1. **Expand** — add the new form beside the old. Nothing breaks; both forms work.
2. **Migrate** — move callers over in batches sized by blast radius (per package, per directory). Each batch is its own task, in the normal per-task template (**Needed now** is "the expand task landed"; **Behaviours** describe that batch's callers now using the new form). CI stays green batch to batch: the old form stays live until the last batch lands.
3. **Contract** — delete the old form, once no caller remains. Its **Needed now** is "every migrate batch landed."

If even one batch can't be independently green — the old and new forms can't coexist for that slice — keep the three-stage shape, but have affected batches share an integration branch, all gating one final integrate-and-verify task. Green is only promised there, not batch to batch.

## Task Ordering

Tasks run one at a time, in listed order. State dependencies as plain prose in a task's Fit note or Files section when one task's output is needed by another (e.g. "depends on Task 2's persisted field") — don't label tasks as parallel-safe or invent a concurrency plan.

## The Executing Agent's Contract

The agent who executes this plan will, for each task:
1. **Invoke the `better-tdd` skill** via the Skill tool before writing any code — not summarise it, not recall it from memory, invoke it
2. Follow that skill exactly to write failing tests from the task's behaviours, implement minimally, and refactor
3. Commit
4. Run a fit-check via a separate agent to verify wider codebase alignment
5. Amend if the fit-check finds issues (up to two rounds)

**When writing the prompt for an implementing subagent**, don't paraphrase or inline the `better-tdd` skill. Tell the agent to invoke it: `"Before writing any code, invoke the better-tdd skill."` The agent has the Skill tool; use it.

Your plan is the input to step 1. Write it so the behaviours are clear enough to become test names and assertions directly.

Before handing the plan over, check it against [RED-FLAGS.md](RED-FLAGS.md).
