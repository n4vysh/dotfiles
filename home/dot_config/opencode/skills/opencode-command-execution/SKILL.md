---
name: opencode-command-execution
description: Use when running Bash, targeting other directories, or using global options.
license: UNLICENSE
compatibility: opencode
---

# OpenCode Command Execution

## Working Directory

- Do not use command options that set the execution or target directory.
- Do not pass absolute paths to those command options.
- Examples: `git -C`, `make -C`, `go -C`, and `terraform -chdir`.
- Run commands in the current working directory by default.
- Use `workdir` in the `bash` tool input for another allowed directory.
- This is required for safety and readability.
    - Execution stays within the current or allowed external directories.
    - Commands stay short without long absolute paths.

## Option Order

- Place options after the subcommand when possible:
    - This keeps commands aligned with Bash tool permission rules.
- Apply this option-order rule to:
    - `kubectl`: `--context`, `--namespace`, and `-n`
    - `helm`: `--kube-context`, `--namespace`, and `-n`
    - `helmfile`: `--kube-context`, `--namespace`, and `-n`
