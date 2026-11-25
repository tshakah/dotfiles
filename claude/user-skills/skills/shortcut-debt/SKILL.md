---
name: shortcut-debt
disable-model-invocation: true
description: Harvest every `shortcut:` comment in the repo into a report, so a deferred limitation doesn't rot into "later means never".
---

# Shortcut Debt

Report only - changes nothing.

Grep the whole tree for the `shortcut:` marker `better-tdd`'s GREEN step leaves, skipping `.git` and anything `.gitignore` ignores:

```
git grep --no-index --exclude-standard -nE '(#|//|/[*]|--) ?shortcut:'
```

If the user names a different marker word, grep for that instead.

One row per marker, grouped by file: `<file>:<line> — <what was simplified>, ceiling: <the limit named in the comment>, upgrade: <the trigger to revisit>`.

Tag any marker with no stated upgrade trigger as `no-trigger` - nothing will ever prompt revisiting those, so they rot silently.

End with the count of markers found and how many are `no-trigger`. None found: "No shortcut debt. Clean ledger."
