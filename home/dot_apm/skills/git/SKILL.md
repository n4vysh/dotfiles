---
name: git
description: Use when running git commands or creating commits.
---

# Git

## Working directory

- Run Git in the current working directory by default.
- For another repository, set the Bash tool's `workdir`.
- Do not use `git -C`.

## Branch

- Use branch name like git-flow.

Format:

`<prefix>/<summary>`

Prefix:

- `feature`
- `bugfix`
- `hotfix`

Example:

```text
feature/add-abc
```

## Commits

- When creating a commit:
    - Write the commit message in English.
    - Use Conventional Commits with gitmoji.
- Follow the repository's existing scope and subject style.

Format:

`<type>[optional scope]: <description>`

Types:

| commit type  | emoji (unicode)  | emoji (shortcode)     | description                                                    |
| :----------- | :--------------- | :-------------------- | :------------------------------------------------------------- |
| `feat`       | ✨               | `:sparkles:`          | A new feature                                                  |
| `fix`        | 🐛               | `:bug:`               | A bug fix                                                      |
| `docs`       | 📝               | `:memo:`              | Documentation only changes                                     |
| `style`      | 🎨               | `:art:`               | Changes that do not affect the meaning of the code             |
| `refactor`   | ♻️               | `:recycle:`           | A code change that neither fixes a bug nor adds a feature      |
| `perf`       | ⚡️               | `:zap:`               | A code change that improves performance                        |
| `test`       | ✅               | `:white_check_mark:`  | Adding missing tests or correcting existing tests              |
| `build`      | 📦️               | `:package:`           | Changes that affect the build system or external dependencies  |
| `ci`         | 💚               | `:green_heart:`       | Changes to our CI configuration files and scripts              |
| `chore`      | 🔨               | `:hammer:`            | Other changes that don't modify src or test files              |
| `revert`     | ⏪️               | `:rewind:`            | Reverts a previous commit                                      |

Example:

```text
feat(opencode): :sparkles: add command skills
```
