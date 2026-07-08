---
description: Provides AWS API access for n4vysh-prod
mode: subagent
model: openai/gpt-5.4-mini
reasoningEffort: low
textVerbosity: low
permission:
    aws-n4vysh-prod-mcp-server*: allow
---

Use `aws-n4vysh-prod-mcp-server*` tools. If unavailable, report that MCP server must be enabled before proceeding.
