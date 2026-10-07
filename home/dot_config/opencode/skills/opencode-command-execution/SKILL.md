---
name: opencode-command-execution
description: Use when running shell commands, scripts, or interpreters.
license: UNLICENSE
compatibility: opencode
---

# OpenCode Command Execution

## Working Directory

- Do not use command options that set the execution or target directory.
- Do not pass absolute paths to those command options.
    - Examples:
        - `git -C`
        - `make -C`
        - `go -C`
        - `terraform -chdir`
- Run commands in the current working directory by default.
- Use `workdir` in the `bash` tool input for another allowed directory.
- This is required for safety and readability.
    - Execution stays within the current or allowed external directories.
    - Commands stay short without long absolute paths.

## Command Execution Priority

- Prefer methods suitable for safe autonomous execution.
- Prefer the simplest execution method in this order:
    1. Direct shell commands.
        - Prefer these for simple and clearly scoped operations.
    2. Inline interpreters when shell commands are impractical.
        - Review the command content before execution.
        - Examples:
            - Python
            - Node.js
            - Ruby
    3. Heredoc-based interpreters for longer inline logic.
        - Review the full content before execution.
        - Example:
            - `python3 - <<'PY'`
    4. Script files only when complex logic requires them.
        - Review the full script before execution.
- Prefer direct shell commands when they are clear and sufficient.
- Avoid temporary files when an earlier method is sufficient.

## Execution Safety

- Autonomous execution must remain within safe, intended operations.
- Do not bypass security boundaries or permission controls.
    - Examples:
        - Sandbox escapes
        - Permission or approval bypasses
- Do not access secrets or credentials unless explicitly required.
    - Examples:
        - API keys
        - Tokens
        - Private keys
- Do not operate on production systems unless explicitly requested.
- Do not perform destructive operations unless explicitly requested.

## Option Order

- Place options after the subcommand when possible:
    - This keeps commands aligned with Bash tool permission rules.
- Apply this option-order rule to:
    - `kubectl`: `--context`, `--namespace`, and `-n`
    - `helm`: `--kube-context`, `--namespace`, and `-n`
    - `helmfile`: `--kube-context`, `--namespace`, and `-n`
