---
name: terraform
description: Use when running Terraform CLI commands.
license: UNLICENSE
compatibility: opencode
---

# Terraform commands

- Run Terraform in the current working directory by default.
- For another configuration, set the Bash tool's `workdir`.
- Do not use Terraform's `-chdir` option.
- Preserve requested targets, variables, and state addresses.

The local permission policy auto-approves these operations:

- `init -backend=false`
- `state list`, `show`, `console`, `fmt`, `test`, `validate`, and `output`
- `terraform-docs` and `tflint`

Other Terraform commands remain subject to Bash permission.
