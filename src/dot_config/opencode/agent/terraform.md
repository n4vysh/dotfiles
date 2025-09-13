---
description: Respond using terraform-server of MCP
mode: subagent
permission:
    edit: ask
    bash: ask
    webfetch: ask
---

Respond using terraform-server of MCP.
Enable with following commands before respond in subagent.

```sh
jq \
    '.mcp."terraform-server".enabled = true' \
    ~/.config/opencode/opencode.jsonc |
    prettier --parser jsonc --trailing-comma none |
    sponge ~/.config/opencode/opencode.jsonc
```

Disable with following commands after respond in subagent.

```sh
jq \
    '.mcp."terraform-server".enabled = false' \
    ~/.config/opencode/opencode.jsonc |
    prettier --parser jsonc --trailing-comma none |
    sponge ~/.config/opencode/opencode.jsonc
```

<!-- markdownlint-configure-file
{
    "MD041": false
}
-->
