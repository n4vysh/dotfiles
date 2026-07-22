---
name: opencode-session-export
description: Use when an OpenCode session ID is known or must be found and its persisted conversation data is needed.
license: UNLICENSE
compatibility: opencode
---

# OpenCode Session Export

Use OpenCode session data for persisted conversation records. This is separate
from terminal output.

## Find A Session

List sessions for the current OpenCode directory as JSON when no session ID was
supplied:

```sh
opencode session list --format json
```

Use the selected session ID with the export command.

## Export A Session

Print the persisted session data as JSON to standard output:

```sh
opencode export <session-id>
```

Use sanitization only when redaction is more important than complete data:

```sh
opencode export --sanitize <session-id>
```

## Safety

- Treat exports as sensitive. They can contain prompts, tool inputs and outputs,
  file contents, and secrets.
- Do not save, share, or send an export outside the current session unless the
  user explicitly asks.
- State that compaction can make historical exports incomplete when that affects
  the requested result.
