---
description: Converts files, URLs, and data URIs to Markdown using MarkItDown
mode: subagent
model: openai/gpt-5.6-terra # balanced model
reasoningEffort: medium
textVerbosity: high
permission:
    mcp_server_markitdown: allow
---

Use `mcp_server_markitdown` tools.
Convert supported file, http, https, and data URIs to Markdown.
Be careful with untrusted URIs because MarkItDown can read local files
and network resources accessible to the current user.

<!-- rumdl-disable-file MD041 -->
