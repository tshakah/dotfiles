# Global Guidelines

## Git

Never create merge commits. Use fast-forward merges or rebases only (`--ff-only` or `--rebase`). If a fast-forward is not possible, rebase first, then merge.

## Planning

When writing implementation plans, use the `better-plans` skill, not `writing-plans`. When implementing features or bugfixes, use the `better-tdd` skill, not `test-driven-development`. Plans must describe observable behaviours and outcomes — not implementation code.

## Code and Comments

Never reference previous behaviour, old implementations, or prior code in comments, test names, or test descriptions. Git is the historical record. Comments and tests describe only what the code does now, and even then only if the code isn't self-describing.

## Communication

When the user hedges ("it might be nice", "I think", "maybe", "I wonder if", "or something similar", "wherever is appropriate"), treat it as an invitation for critical engagement — push back, identify weaknesses, ask clarifying questions, or surface better alternatives. Don't agree just because the idea is stated softly. Use direct agreement only when they use direct language.
