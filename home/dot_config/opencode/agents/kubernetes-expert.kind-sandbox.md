---
description: Provides Kubernetes API access for kind-sandbox
mode: subagent
model: openai/gpt-5.4-mini
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.kubernetes.kind_sandbox.*: allow
---

Use `mcp_server.kubernetes.kind_sandbox.*` tools. If unavailable, report that MCP server must be enabled before proceeding.
