---
description: Provides Grafana API access
mode: subagent
model: openai/gpt-5.6-luna
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.grafana.*: allow
---

Use `mcp_server.grafana.*` tools.
If unavailable, report that MCP server must be enabled before proceeding.

<!-- rumdl-disable-file MD041 -->
