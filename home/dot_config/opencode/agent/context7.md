---
description: Respond using context7-server of MCP
mode: subagent
permission:
    edit: ask
    bash: ask
    webfetch: ask
---

Respond using context7-server of MCP.
Enable with following commands before respond in subagent.

```sh
jq \
    '.mcp."context7-server".enabled = true' \
    ~/.config/opencode/opencode.jsonc |
    prettier --parser jsonc --trailing-comma none |
    sponge ~/.config/opencode/opencode.jsonc
```

Disable with following commands after respond in subagent.

```sh
jq \
    '.mcp."context7-server".enabled = false' \
    ~/.config/opencode/opencode.jsonc |
    prettier --parser jsonc --trailing-comma none |
    sponge ~/.config/opencode/opencode.jsonc
```

<!-- markdownlint-configure-file
{
    "MD041": false
}
-->
