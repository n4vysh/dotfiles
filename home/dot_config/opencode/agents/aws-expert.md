---
description: |
    Inspects live AWS resources in selected accounts and environments
    Searches AWS docs for service behavior, design, and operations
mode: subagent
model: openai/gpt-5.6-terra # balanced model
reasoningEffort: medium
textVerbosity: high
permission:
    mcp_server_aws_*: allow
---

Use `mcp_server_aws_*` tools.
If unavailable, report that MCP server must be enabled before proceeding.

<!-- rumdl-disable-file MD041 -->
