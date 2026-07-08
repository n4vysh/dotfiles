---
description: Provides Grafana API access for n4vysh
mode: subagent
model: openai/gpt-5.4-mini
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.grafana.n4vysh.*: allow
---

Use `mcp_server.grafana.n4vysh.*` tools. If unavailable, report that MCP server must be enabled before proceeding.
