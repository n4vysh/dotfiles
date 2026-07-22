---
name: opencode-tool-selection
description: Use when choosing between a specialized tool and a Bash command.
license: UNLICENSE
compatibility: opencode
---

# OpenCode Tool Selection

- Prefer specialized tools over Bash commands when possible:
    - Use Read instead of `cat`, `head`, or `tail`.
    - Use Edit instead of `sed` or `awk`.
    - Use Write instead of shell redirection.
    - Reserve Bash for terminal operations that require shell execution.
