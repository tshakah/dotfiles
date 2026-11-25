---
name: caveman-compress
disable-model-invocation: true
description: Shrink a memory file's prose into caveman-speak to cut input tokens — applied as a reviewed edit in this conversation, no external call, no backup directory.
---

# Caveman Compress

Shrink prose in a memory file (`CLAUDE.md`, `AGENTS.md`, a todo list, project notes) into caveman-speak, cutting input tokens it adds every session it loads. Applied directly as an edit you review in this conversation — no separate process, no external call beyond what this session already makes, no backup directory: edit lands in your working tree, where git already holds the original.

## Trigger

`/caveman-compress <filepath>`, or when asked to shrink a memory file.

## Scope

Only natural-language files: `.md`, `.txt`, extensionless prose. Never `.py`, `.js`, `.ts`, `.json`, `.yaml`, `.env`, or other code/config — if unsure whether something is code or prose, leave unchanged. A mixed file: compress only its prose sections, leave code blocks untouched.

## Remove

- Articles: a, an, the — only where sentence still reads in one pass
- Filler: just, really, basically, actually, simply, essentially, generally
- Pleasantries: "sure", "certainly", "of course", "happy to", "I'd recommend"
- Hedging: "it might be worth", "you could consider", "it would be good to"
- Redundant phrasing: "in order to" → "to", "make sure to" → "ensure"
- Connective fluff: "however", "furthermore", "additionally"

## Preserve exactly, never touch

- Code blocks (fenced or indented) and inline code
- URLs, links, file paths, commands
- Technical terms, library/API names, proper nouns
- Dates, version numbers, numeric values, environment variables
- Every negation — not/never/no/only/except: same rule as `caveman` voice skill's Why #4, for the same reason
- Anything wrapped in `<!-- nocompress --> … <!-- /nocompress -->`, each tag on its own line

## Preserve structure

Headings (exact text), bullet/numbered nesting, table structure (compress cell text only, keep the table), frontmatter.

## Compress

Short synonyms ("fix" not "implement a solution for"), fragments where they still read clearly, drop "you should"/"remember to" and just state the action, merge bullets that say the same thing twice, keep one example where several show the same pattern.

## Stay fluent

Compression that degrades into broken grammar fails even if it counts fewer tokens: a memory file reading worse is a worse memory file. Hold the same bar the `caveman` voice skill states for itself: **a voice, not broken grammar.** If a cut makes a sentence harder to parse correctly on the first read, don't make that cut.

## Pattern

Original: "You should always make sure to run the test suite before pushing any changes to the main branch. This is important because it helps catch bugs early and prevents broken builds from being deployed to production."

Compressed: "Run tests before push to main. Catch bugs early, prevent broken prod deploys."

## Process

1. Read the target file.
2. Apply the rules above sentence by sentence, holding fluency as the bar — not a mechanical find-replace. Done when every sentence has been checked against Remove/Preserve/Compress and still reads correctly on a first pass — not when the file merely looks shorter.
3. Make the edit via the Edit tool. The user reviews and commits it, or not.
