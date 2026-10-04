import { execFile } from "node:child_process";
import { Plugin } from "@opencode/plugin";

export default Plugin.define({
  id: "rtk",
  setup: async (ctx) => {
    await ctx.tool.hook("execute.before", async (event) => {
      if (event.tool !== "shell") return;
      const input = event.input;
      if (!input || typeof input !== "object" || !("command" in input)) return;
      const command = input.command;
      if (typeof command !== "string" || !command.trim()) return;

      try {
        const rewritten = await new Promise<string | undefined>((resolve) => {
          execFile(
            "rtk",
            ["rewrite", command],
            { encoding: "utf8", timeout: 3000 },
            (error, stdout) => {
              // RTK also returns rewrites with exit code 3.
              if (error && (error.killed || error.signal || error.code !== 3)) {
                resolve(undefined);
                return;
              }
              resolve(stdout.trim());
            },
          );
        });
        if (rewritten && rewritten !== command) input.command = rewritten;
      } catch {
        return;
      }
    });
  },
});
