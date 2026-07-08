---
description: Provides Kubernetes API access
mode: subagent
model: openai/gpt-5.4-mini
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.kubernetes.*: allow
---

Use `mcp_server.kubernetes.*` tools. If unavailable, report that MCP server must be enabled before proceeding.
