---
name: opencode-search
description: Use when starting a file search or broad codebase exploration.
license: UNLICENSE
compatibility: opencode
---

# OpenCode Search and Exploration

- Prefer Task for file searches to reduce context use.
- Proactively use specialized agents when their descriptions match the task.
- Use Task for broad codebase exploration:
    - Use it when gathering context from several files.
    - Use it for questions that do not target a specific file or symbol.
    - Do not run direct search commands for broad exploration.
- Use Read directly when you already know the specific file to inspect.
