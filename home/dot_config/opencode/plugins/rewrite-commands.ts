import { Plugin } from "@opencode/plugin";

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

export default Plugin.define({
  id: "rewrite-commands",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", (event) => {
      const tool = event.tool.toLowerCase();
      if (tool !== "bash" && tool !== "shell") return;

      const args = event.input;
      if (!args || typeof args !== "object") return;

      const command = (args as Record<string, unknown>).command;
      if (typeof command !== "string" || !command) return;
      (args as Record<string, unknown>).command = rewriteCommand(command);
    });
  },
});
