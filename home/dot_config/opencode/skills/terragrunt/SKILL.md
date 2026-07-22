---
name: terragrunt
description: Use when running Terragrunt CLI commands.
license: UNLICENSE
compatibility: opencode
---

# Terragrunt commands

- Run Terragrunt in the current working directory by default.
- For another configuration, set the Bash tool's `workdir`.
- Preserve requested targets, variables, and state addresses.

The local permission policy auto-approves these operations:

- `init -backend=false`
- `validate`
- `output`
- `state list`
- `show`

Other Terragrunt commands remain subject to Bash permission.
