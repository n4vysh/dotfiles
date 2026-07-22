---
name: trash
description: Use before running `rm` or otherwise deleting files or directories directly or indirectly.
license: UNLICENSE
compatibility: opencode
---

# Trash

- Use `trash` instead of `rm` for every file or directory deletion.
- Keep target paths unchanged unless the user approves a scope change.
- Do not bypass the configured `rm` denial with aliases or absolute paths.
