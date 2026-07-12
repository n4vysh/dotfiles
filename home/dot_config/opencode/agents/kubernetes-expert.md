---
description: Provides Kubernetes API access
mode: subagent
model: openai/gpt-5.6-luna
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.kubernetes.*: allow
---

Use `mcp_server.kubernetes.*` tools. If unavailable, report that MCP server must be enabled before proceeding.
