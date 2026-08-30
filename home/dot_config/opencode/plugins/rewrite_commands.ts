import type { Plugin } from "@opencode-ai/plugin";

const rewrites = [
  {
    // NOTE: use pinned local binary instead of `npx ctx7@latest` in find-docs skill
    // https://github.com/upstash/context7/blob/ctx7%400.5.9/skills/find-docs/SKILL.md
    pattern: /^(\s*)npx\s+ctx7(?:@[a-zA-Z0-9._+-]+)?(?=\s|$)/,
    replacement: "$1ctx7",
  },
];

export function rewriteCommand(command: string): string {
  for (const { pattern, replacement } of rewrites) {
    if (pattern.test(command)) return command.replace(pattern, replacement);
  }

  return command;
}

export const RewriteCommandsPlugin: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      const tool = String(input?.tool ?? "").toLowerCase();
      if (tool !== "bash" && tool !== "shell") return;

      const args = output?.args;
      if (!args || typeof args !== "object") return;

      const command = (args as Record<string, unknown>).command;
      if (typeof command !== "string" || !command) return;
      (args as Record<string, unknown>).command = rewriteCommand(command);
    },
  };
};
