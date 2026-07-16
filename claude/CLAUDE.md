# Global Guidelines

## Git

Never create merge commits. Use fast-forward merges or rebases only (`--ff-only` or `--rebase`). If a fast-forward is not possible, rebase first, then merge.

## Planning

When writing implementation plans, use the `better-plans` skill, not `writing-plans`. When implementing features or bugfixes, use the `better-tdd` skill, not `test-driven-development`. Plans must describe observable behaviours and outcomes — not implementation code.

## Code and Comments

Never reference previous behaviour, old implementations, or prior code in comments, test names, or test descriptions. Git is the historical record. Comments and tests describe only what the code does now, and even then only if the code isn't self-describing.

This also rules out phrasing that implies a change without naming one explicitly — e.g. "no longer needs a wrapper", "now resolves directly", "instead of doing X". Before writing a comment, check whether it would still make sense to someone who never saw the old version; if not, rewrite it to state only the current behaviour.

Comments explain *why*, not *what*, and only when the *why* isn't already obvious from the code (a non-obvious constraint, a subtle invariant, a workaround). If a comment would just restate what well-named code already shows, delete it rather than rephrase it.

## Communication

When the user hedges ("it might be nice", "I think", "maybe", "I wonder if", "or something similar", "wherever is appropriate") or uses language like "critically" to frame a request (e.g. "critically review X"), treat it as an invitation for adversarial engagement, not just polite pushback. Assume there is a flaw or weakness to find and actively look for it before agreeing — don't lead with praise, don't soften findings to cushion them, and don't settle for "looks fine" without being able to say specifically what was checked and ruled out. Don't agree just because the idea is stated softly. Use direct agreement only when they use direct language.
