---
name: opencode-rtk-plugin
description: Use when an agent is about to run `rtk` directly, prefix a command with `rtk`, or run `rtk rewrite`.
license: UNLICENSE
compatibility: opencode
---

# OpenCode RTK Plugin

## Command Output

- Shell command output may be replaced by `rtk`:
    - The OpenCode plugin automatically runs `rtk rewrite <command>` for
      every Bash or Shell command.
    - The plugin is `~/.config/opencode/plugins/rtk.ts`.
    - It replaces the command only when the rewrite result is non-empty and
      differs from the original command.
    - `rtk` may summarize, compact, or truncate output.
    - This rewriting reduces token use.
- Do not prefix normal commands with `rtk` based on your own judgment.
- Do not run `rtk rewrite` manually; pass the original command to the Bash tool.
- Treat rewritten output as valid unless a specific inconsistency exists:
    - Do not bypass rewritten output without a concrete reason.
    - Treat explicit errors as errors.
    - Do not reject output only because it is shorter than usual.
    - Do not reject output only because its format differs.
- If exact raw output is required:
    - Rerun the command with `RTK_DISABLED=1`.
- When a command fails:
    - `rtk` saves the unfiltered output.
    - `rtk` reports the path that contains the unfiltered output.

## Implementation

- The plugin processes each Bash and Shell command before execution.
- The original command is retained when:
    - RTK is unavailable.
    - The rewrite is empty or unchanged.
    - Rewriting fails.
- Change rewrite behavior in RTK's registry, not in the delegating plugin.
