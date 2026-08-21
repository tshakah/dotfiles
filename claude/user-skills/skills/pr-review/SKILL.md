---
name: pr-review
disable-model-invocation: true
description: Use to review someone else's pull request across correctness, security, test coverage, comments, commit messages, and wider-codebase fit — without touching their branch history or posting anything. Checks the PR out into a throwaway worktree, resolves what was intended from the ticket and PR description, then spawns one adversarial agent per dimension and hands the user a severity-grouped list to post themselves. Takes a PR reference (number or URL) as args.
---

# PR Review

## Purpose

Reviewing someone else's PR needs the same adversarial rigor as `comment-check`, `commit-check`, and `fit-check` — but none of the "fix it yourself" machinery those skills use, since you don't own the branch. It also needs dimensions those skills deliberately leave out: they assume correctness was already established by whoever wrote the code. On someone else's PR that assumption doesn't hold, so this skill adds correctness, security, and test-coverage dimensions alongside them.

Never rewrite, rebase, or force-push someone else's branch. If a finding needs a structural fix (split/squash/reorder a commit, restructure a change), say so in the finding and let the author decide — don't offer to do it for them.

## Input

Supplied via `args`: a PR number, URL, or enough to resolve one with `gh pr view`. If ambiguous or missing, ask which PR.

## Step 1: Check the PR out into a worktree

Review agents must read surrounding code at the PR's head, not at whatever is in the user's working tree. Reviewing from `gh pr diff` alone gives every agent the wrong codebase to explore, and makes `HEAD`-relative commands in the extracted briefs silently wrong.

Use `wt` (worktrunk) rather than raw `git worktree`/`git fetch` — it resolves a PR reference to its ref directly, handling same-repo and fork PRs with one command:

```bash
gh pr view <n> --json number,title,body,author,baseRefName,headRefName,additions,deletions,changedFiles
wt --config-set 'worktree-path="{{ repo_path }}/.claude/worktrees/pr-{{ branch | sanitize }}"' switch pr:<n> --no-cd --no-hooks --format json
```

The JSON result's `path` field is the worktree — run every subsequent command, and every agent, there. `--no-cd` keeps this from trying to change the orchestrating shell's directory (which doesn't carry between tool calls anyway); `--format json` is what makes the path reliably parseable instead of scraped from human-readable output. `--no-hooks` skips any project `pre-start`/`post-start` hooks (dependency installs, a dev server) — this skill does static review, not a running app.

For a same-repo PR, `wt` checks out a local branch tracking `origin/<branch>`. For a fork PR, it fetches the ref without a tracking branch and points `pushRemote` at the fork. Neither case is a reason to push, rebase, or rewrite anything from this worktree — see the rule above.

Always place the worktree under the current repo's `.claude/worktrees/` directory — never `/tmp` or a sibling directory — via the `--config-set worktree-path=...` override above, so every checkout ends up in one predictable, already-gitignored location regardless of the caller's own `~/.config/worktrunk/config.toml`.

Record the base: `BASE=$(git merge-base origin/<baseRefName> HEAD)`. The PR's diff is `git diff $BASE HEAD`; its commit range is `$BASE..HEAD`.

If `wt` isn't installed, or the worktree can't be created (dirty state, no write access, shallow clone), say so and fall back to `gh pr diff` — but state explicitly in the final report that the fit and correctness dimensions ran without codebase context and are therefore weaker.

## Step 2: Resolve what was intended

Three sources, in priority order:

1. **The ticket.** Look for a ticket reference in the PR body or branch name. Resolve it against whichever tracker is actually configured — Jira via the Atlassian MCP tools if authenticated, `gh issue view` for GitHub. Don't assume a tracker or hardcode a workspace ID; check what's available. If it doesn't resolve, say so and carry on rather than guessing at its contents.
2. **Linked material.** If the ticket body or comments link further tickets or wiki pages, fetch up to 5 of them as *supplementary* context, clearly labelled as such. Don't treat them as primary requirements. Skip any that fail; don't block the review.
3. **The PR description** (`gh pr view <n> --json body,title`).

State the resolved intent, and its source, before spawning agents. If neither a ticket nor a substantive PR description exists, say so — that absence is itself a finding, and it means the alignment check below can't run.

## Step 3: Alignment check

Do this inline, before spawning agents — it's cheap and its output feeds the fit dimension. Compare the three sources against each other:

| Source | What it tells you |
|---|---|
| Ticket | What was asked for |
| PR description | What the author claims they did |
| Diff | What actually changed |

Flag: **scope creep** (changes in the diff that neither source accounts for), **missing work** (acceptance criteria the diff doesn't address), **description drift** (the description describes something the diff doesn't do), **silent changes** (functional changes explained nowhere).

## Step 4: Read what has already been said

`gh pr view <n> --comments`, plus review threads via `gh api repos/{owner}/{repo}/pulls/<n>/comments`.

Summarise unresolved threads and blocking feedback, and pass the list of already-raised points to every agent with the instruction not to re-raise them. Re-reporting a point a human made two days ago wastes the author's time and makes the whole review look automated.

## Step 5: Spawn one agent per dimension, in parallel

Do not merge dimensions into a single agent: one reviewer covering everything at once dilutes the "assume a flaw exists" posture per-dimension, and an easy "looks fine" on one axis bleeds into how hard it looks at the next.

Every agent gets: the worktree path as its working directory, the diff and commit-range commands from Step 1, the resolved intent from Step 2, and the already-raised list from Step 4.

**Three dimensions reuse the sibling skills' briefs.** Before spawning, read the current `SKILL.md` of `comment-check`, `commit-check`, and `fit-check` (read-only — do not edit them) and extract each one's quoted agent brief **verbatim**. Do not paraphrase or reconstruct from memory: the point is to pick up whatever each skill currently says, including changes made since this skill was written. Where a brief contains a bracketed placeholder for the diff command, substitute `git diff $BASE HEAD`. Because the agent runs in the checked-out worktree, the briefs' `HEAD`-relative commands resolve to the PR's head, which is what they mean.

1. **Comments** — `comment-check`'s brief, scoped to comment lines the PR diff adds or changes.
2. **Commits** — `commit-check`'s brief, scoped to `$BASE..HEAD`.
3. **Fit** — `fit-check`'s brief, using Step 2's resolved intent as "what was intended" and Step 3's alignment findings as a starting point rather than a conclusion.

**Three dimensions are specific to reviewing code you didn't write.** Each gets the shared preamble below plus its own body.

> Shared preamble: You are reviewing a pull request you did not write. Assume there is a defect of your dimension's kind in this diff, and that your job is to find it. The author already believes this change is correct — agreeing with them adds nothing. Do not lead with praise, do not soften a finding with "minor" or "nitpick" hedging, and do not filter findings by a confidence threshold: report what you found and state your uncertainty in words. Read the surrounding code before flagging anything — at least the whole file, and the callers, for any change you intend to call out. Do not score anything out of 10. These points have already been raised on the PR; don't repeat them: [list].

4. **Correctness** — Trace each changed function's behaviour for the inputs the diff makes newly reachable. Look for: logic that's inverted or off-by-one; null/nil/undefined and empty-collection paths; error paths that swallow, log-and-continue, or return a plausible-looking default instead of failing; concurrency and ordering assumptions; resource cleanup; behaviour changes for existing callers the diff didn't update. For each, give the concrete input or state that produces the wrong result. Only conclude a changed function is sound after stating, for that function, which of these you checked and why each held.

5. **Security** — Focus on code-level patterns automated scanners miss. Look for: authentication and authorization gaps on newly reachable paths (including "the caller already checked" assumptions the diff makes); input that reaches a query, shell, filesystem path, template, or deserializer without validation; secrets or credentials in code, config, logs, or error messages; data exposed to a wider audience than before; changes to session, token, or crypto handling. State the attacker, the entry point, and what they get. If a path looks safe because of a check elsewhere, name the check and the file it's in.

6. **Test coverage** — Judge behavioural coverage, not line coverage. For each behaviour the diff adds or changes, ask whether a test would fail if that behaviour regressed — and if a test exists, whether it asserts the behaviour or merely exercises it. Look for: new branches and error paths with no test; validation added with no invalid-input case; tests changed to accommodate the new behaviour rather than passing naturally; tests coupled to implementation detail such that a refactor breaks them without a behaviour change. Name the specific untested behaviour and the failure it would let through, not a coverage percentage.

A dimension may be skipped only when the diff plainly can't contain that class of defect (e.g. no test dimension on a pure documentation PR). State any skip and its reason in the report.

## Step 6: Report

This skill never posts to the PR. Its job ends at handing the user a list to work through themselves.

Group by severity, not by agent — the author doesn't care which agent found it:

- **Blocking** — bugs, security vulnerabilities, data-loss risk, missing work against the ticket's acceptance criteria
- **Important** — untested new behaviour, error handling that hides failures, misleading comments or commit messages, fit problems that will cause drift
- **Minor** — style, redundant comments, wording
- **Question** — needs the author's judgment; a `Discuss` finding from any dimension lands here

`Amend` findings from the comment/commit/fit dimensions are Minor unless the finding is that something states something untrue — a comment that misdescribes the code, or a commit message that misdescribes its diff — which is Important.

Number every finding within its section, prefixed with the section's initial: `B1`, `B2`, ... under Blocking, `I1`, `I2`, ... under Important, `M1`, `M2`, ... under Minor, `Q1`, `Q2`, ... under Question. Restart the count at 1 in each section. This gives the user a stable short handle (e.g. "M2") to reference when responding to a specific finding, instead of quoting it back.

Each finding: file:line (or commit sha), what's wrong, and why — one to three lines. Drafting the text the user could paste as a review comment is fine and useful. Omit empty sections. End with the unresolved-thread summary from Step 4 if there is one.

Do not call `gh pr review`, `gh pr comment`, or `gh api` with a write method, and do not offer to post on the user's behalf. Posting, if it happens, is the user's action alone.

## Step 7: Clean up

Offer to remove the worktree: `wt remove --format json <path>` (the path from Step 1's JSON result). Ask first — the user may want to keep poking at the branch. Pass `--no-delete-branch` if they want to keep it after the worktree goes.

## Red flags — stop and reconsider

- Reviewing from `gh pr diff` alone when a worktree checkout was possible — the fit and correctness dimensions then explore the wrong codebase
- `gh pr checkout` in the user's main working tree instead of a worktree — this skill must not disturb their branch state
- `wt switch` without `--no-cd --format json` — without `--format json` the resulting path isn't reliably parseable, and `--no-cd` is what keeps a non-interactive tool call from trying to change a shell that isn't there
- Rebasing, rewording, or force-pushing the PR branch — that's the author's call, not the reviewer's
- Running the dimensions as one agent instead of independent ones
- Editing `comment-check`, `commit-check`, or `fit-check`'s `SKILL.md` while extracting their brief — this skill only reads them
- Paraphrasing a brief from memory instead of reading the current file — the whole point is picking up whatever it says now
- An agent filtering by a confidence threshold, or scoring anything out of 10 — both are ways of producing a quiet review without saying what was ruled out
- Any agent being agreeable or complimentary instead of trying to find what's wrong
- Accepting "looks fine" from a dimension without it stating what it specifically checked
- Treating "no findings" as the default and skipping the review to get there
- Listing findings without the per-section `B1`/`I1`/`M1`/`Q1`-style numbering — the user relies on it to reference a specific finding
- Skipping the intent resolution and inventing scope for the fit dimension
- Re-raising a point an existing PR comment already made
- Posting anything to the PR — this skill only produces a list for the user
