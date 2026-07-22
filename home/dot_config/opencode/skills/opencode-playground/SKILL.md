---
name: opencode-playground
description: Use before creating temporary data outside the workspace.
license: UNLICENSE
compatibility: opencode
---

# OpenCode playground

Store temporary files outside the workspace only under:

```text
~/Workspaces/localhost/tmp/opencode-playground/
```

- Do not use `/tmp` or another external directory as a fallback.
- Keep task-specific temporary files contained under this directory.
- The OpenCode external-directory permission already allows this path.
