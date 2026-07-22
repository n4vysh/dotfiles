---
name: git
description: Use when running git commands or creating commits.
license: UNLICENSE
compatibility: opencode
---

# Git

## Working directory

- Run Git in the current working directory by default.
- For another repository, set the Bash tool's `workdir`.
- Do not use `git -C`.

## Commits

- When creating a commit:
    - Write the commit message in English.
    - Use Conventional Commits with gitmoji.
- Follow the repository's existing scope and subject style.

Example:

```text
feat(opencode): :sparkles: add command skills
```
