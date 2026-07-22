---
description: Provides Grafana API access
mode: subagent
model: openai/gpt-5.6-terra # balanced model
reasoningEffort: medium
textVerbosity: high
permission:
    mcp_server_grafana_*: allow
---

Use `mcp_server_grafana_*` tools.
If unavailable, report that MCP server must be enabled before proceeding.

<!-- rumdl-disable-file MD041 -->
