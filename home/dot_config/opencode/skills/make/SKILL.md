---
name: make
description: Use when running make commands.
license: UNLICENSE
compatibility: opencode
---

# Make commands

- Run `make` in the current working directory by default.
- For another project, set the Bash tool's `workdir`.
- Do not use `make -C`.
- Preserve the requested targets and variable assignments.
- Make commands remain subject to the default Bash permission prompt.
