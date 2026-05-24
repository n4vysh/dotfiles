---
name: ni
description: Use ni command family for package manager operations. Use when handling Node package install, run, execute, update, remove, clean install, or dedupe workflows.
license: UNLICENSE
compatibility: opencode
---

# ni

Use `ni` command family instead of direct `npm`, `yarn`, `pnpm`, or `bun`
commands.

## Quick Rules

- Use `ni` for install/add operations.
- Use `nr` for npm scripts defined in `package.json`.
- Use `nlx` for temporary package execution (`npx`/`dlx` style).
- Use `nup` for upgrade operations.
- Use `nun` for uninstall/remove operations.
- Use `nci` for clean install.
- Use `nd` for dedupe.
- Use `na` only when the above commands cannot express the requested action.

## Command Selection

- **Install/add dependency**: `ni <pkg>`
- **Run package.json script**: `nr <script>`
- **Run direct command in repository**: `na exec <command>`
- **Temporary binary execution**: `nlx <command>`
- **Upgrade dependencies**: `nup`
- **Remove dependency**: `nun <pkg>`
- **Clean install**: `nci`
- **Dedupe**: `nd`

## Priority Order

1. Match to one of: `ni`, `nr`, `nlx`, `nup`, `nun`, `nci`, `nd`.
2. If direct command execution in a repository is requested, prefer
   `na exec <command>`.
3. If npm script execution is requested, prefer `nr <script>`.
4. If none of the above can satisfy the request, fallback to `na ...`.

## Examples

```bash
# install deps
ni

# add dependency
ni vitest -D

# run npm script
nr test

# direct command execution in repository (pnpm vitest-like intent)
na exec vitest

# temporary package execution
nlx vitest

# upgrade
nup

# uninstall
nun vitest

# clean install
nci

# dedupe
nd
```

## Fallback Policy

Fallback to `na` when:

- requested behavior is not representable by `ni`, `nr`, `nlx`, `nup`, `nun`,
  `nci`, or `nd`
- required subcommand/flag is unavailable in those commands
- command mapping is unclear and `na` is needed to preserve exact behavior

When falling back:

- prefer `na exec <command>` for repository-local direct command execution
- keep arguments unchanged to preserve user intent
