# Out-of-Scope Knowledge Base

`.out-of-scope/` in a repo stores persistent records of rejected feature requests. It does two jobs: keeps the reasoning behind a rejection from getting lost once the conversation that produced it is gone, and lets a later request for the same thing be recognized before a duplicate ticket gets drafted.

## Directory structure

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

One file per **concept**, not per request. Multiple asks for the same thing live under one file.

## File format

Write it as a short, relaxed design note, not a database entry — paragraphs and examples that make the reasoning legible to someone hitting it cold.

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single color palette defined in
`ThemeConfig`. Supporting multiple themes would require a theme context
provider wrapping the component tree, per-component theme-aware style
resolution, and a persistence layer for the preference — a significant
architectural change the project's focus on content authoring doesn't
justify. Theming is a concern for downstream consumers who embed or
redistribute the output.

## Prior requests

- Ticket PROJ-142: "Add dark mode support"
- Ticket PROJ-187: "Night theme for accessibility"
```

### Naming the file

A short, descriptive kebab-case concept name: `dark-mode.md`, `plugin-system.md`. Someone browsing the directory should recognize what was rejected without opening the file.

### Writing the reason

Reference what makes the rejection durable: project scope or philosophy, a technical constraint, a strategic choice already made elsewhere. Avoid temporary circumstances ("not a priority right now") — those are deferrals, not rejections, and don't belong here.

## Matching a new request

Match by concept similarity, not keyword: "night theme" matches `dark-mode.md`. If the match is real, surface the prior decision and ask whether it still holds before drafting anything.

## When to write here

Only when a genuine feature request is rejected — never when something is closed because it's **already implemented**. A shipped feature isn't a rejection; recording it here would make a future match read as "we refuse to build this" when the truth is "this already exists." Point the requester at where it already lives instead.

## Updating or removing

If the decision gets reversed, delete or rewrite the file. Don't leave a stale rejection standing once the reasoning behind it no longer holds.
