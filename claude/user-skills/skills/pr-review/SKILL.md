---
name: pr-review
description: Use to review someone else's pull request across comments, commit messages, and wider-codebase fit — without touching their branch history or posting anything. Spawns three independent agents, one per dimension, reusing the same adversarial briefs as comment-check, commit-check, and fit-check, then lists findings for the user to work through and post themselves. Takes a PR reference (number or URL) as args.
---

# PR Review

## Purpose

Reviewing someone else's PR needs the same adversarial rigor as `comment-check`, `commit-check`, and `fit-check` — but none of the "fix it yourself" machinery those skills use, since you don't own the branch. This skill runs the same three check dimensions as independent parallel agents, then lists the findings for the user instead of applying local edits, rebases, force-pushes, or posting anything to the PR.

Never rewrite, rebase, or force-push someone else's branch. If a finding needs a structural fix (split/squash/reorder a commit, restructure a change), say so in the review comment and let the author decide — don't offer to do it for them.

## Input

Supplied via `args`: a PR number, URL, or enough to resolve one with `gh pr view`. If ambiguous or missing, ask which PR.

## Scope

- Resolve the PR's diff: `gh pr diff <number>`.
- Resolve the PR's commit range: `gh pr view <number> --json commits`, or `git log <base>..<head>` if the branch is checked out locally via `gh pr checkout <number>`.
- Resolve "what was intended": the PR's own description/title (`gh pr view <number> --json body,title`), falling back to a linked ticket if referenced, falling back to asking the user.

State the resolved scope (diff, commit range, intent source) before spawning agents.

## Process

Before spawning any agent, read the current `SKILL.md` of `comment-check`, `commit-check`, and `fit-check` (read-only — do not edit them) and extract each one's quoted agent brief verbatim. Do not paraphrase or reconstruct a brief from memory: the point is to pick up whatever each skill currently says, including any changes made to it since this skill was written.

Spawn three agents in parallel — one per dimension. Do not merge them into a single agent: a single reviewer covering all three dimensions at once dilutes the "assume a flaw exists" posture per-dimension, and an easy "looks fine" on one axis tends to bleed into how hard it looks at the next.

1. **Comments** — the brief extracted from `comment-check`, scoped to comment lines added/changed in the PR diff.
2. **Commits** — the brief extracted from `commit-check`, scoped to the PR's commit range.
3. **Fit** — the brief extracted from `fit-check`, using the PR's resolved intent as "what was intended."

Each agent classifies findings **Amend** (small, clearly actionable) or **Discuss** (needs the author's judgment) — same classification as the underlying skills. Both classes become review comments here; there is no "apply Amend automatically" step, because you don't have (or want) write access to apply it to.

## Reporting findings

This skill never posts to the PR. Its job ends at handing the user a list to work through themselves.

- Group findings by file/line (comments, fit) or by commit (commit messages).
- Present every finding — Amend and Discuss both — with enough detail to act on: file/commit, the specific issue, and which dimension (comments/commits/fit) raised it.
- Do not draft PR comment text, do not call `gh pr review`/`gh pr comment`/`gh api`, and do not offer to post on the user's behalf. Posting, if it happens, is the user's action alone.

## Red flags — stop and reconsider

- Rebasing, rewording, or force-pushing the PR branch — that's the author's call, not the reviewer's
- Running the three checks as one agent instead of three independent ones
- Editing `comment-check`, `commit-check`, or `fit-check`'s `SKILL.md` while extracting their brief — this skill only reads them
- Paraphrasing a brief from memory instead of reading the current file — the whole point is picking up whatever it says now
- Posting, or offering to post, anything to the PR — this skill only produces a list for the user
- Treating "no findings" as the default and skipping the review to get there
- Skipping the "what was intended" resolution and inventing scope for the fit-check dimension
