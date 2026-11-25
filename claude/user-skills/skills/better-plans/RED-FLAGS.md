# Red Flags in Your Own Plan

- You wrote a function body, even in comments
- You specified a data structure layout for something internal
- The "behaviour" section reads like a recipe ("call X, then Y, then Z")
- No fit note, but the task touches an abstraction that exists elsewhere
- The task description says "implement X using Y" rather than "after this, X must be true"
- No seam named in the fit note, or more than one where a single higher seam would cover the same behaviours
- A strangler-fig refactor forced into a single task's per-task template instead of expand/migrate/contract
