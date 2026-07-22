---
name: opencode-mcp-servers
description: Use when selecting or enabling a credential-backed resource MCP server.
license: UNLICENSE
compatibility: opencode
---

# OpenCode MCP Servers

- Keep credential-backed resource MCP servers disabled by default:
    - Do not suggest enabling them unless direct inspection is required.
- Suggest an MCP Server based on the resource being inspected:
    - AWS resources: AWS MCP Server
    - Kubernetes resources: Kubernetes MCP Server
    - Grafana resources: Grafana MCP Server
