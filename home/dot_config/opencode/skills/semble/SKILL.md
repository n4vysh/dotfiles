---
name: semble
description: Use when searching code or finding related implementations.
license: UNLICENSE
compatibility: opencode
---

# Semble Code Search

- For code searches, start with `semble search`:
    - Describe the behavior or provide a symbol name.

```bash
semble search "authentication flow" ./my-project
semble search "save_pretrained" ./my-project
semble search "save model to disk" ./my-project --top-k 10
```

- Use `semble find-related` for code similar to a promising result:
    - Pass the result's `file_path` and `line` values.

```bash
semble find-related src/auth.py 42 ./my-project
```

- Set the `path` argument as follows:
    - It defaults to the current directory when omitted.
    - It accepts Git URLs.
- Use grep only for exhaustive literal matches or quick exact confirmation.
- Inspect a full file only when a search result lacks enough context.
