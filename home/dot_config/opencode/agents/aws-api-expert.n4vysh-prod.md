---
description: Provides AWS API access for n4vysh-prod
mode: subagent
model: openai/gpt-5.4-mini
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.aws.n4vysh_prod.*: allow
---

Use `mcp_server.aws.n4vysh_prod.*` tools. If unavailable, report that MCP server must be enabled before proceeding.
