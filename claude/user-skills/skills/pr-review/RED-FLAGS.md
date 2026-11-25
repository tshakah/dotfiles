# Red flags — stop and reconsider

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
- Re-running the full test suite locally to confirm what CI already reported clean
- Treating the Step 1b hotspot list as a finding rather than a scrutiny hint, or skipping full review of files it didn't flag
