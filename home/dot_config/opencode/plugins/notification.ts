import { execFile } from "node:child_process";
import { stat } from "node:fs/promises";
import { promisify } from "node:util";
import { Plugin } from "@opencode/plugin";

const run = promisify(execFile);

export default Plugin.define({
  id: "notification",
  async setup(ctx) {
    // NOTE: disable when running nono sandbox on WSL
    //       nono not support plan9 (pwsh.exe and BurntToast)
    if (
      process.env.NONO_CAP_FILE !== undefined &&
      (await stat("/mnt/wsl").catch(() => undefined))?.isDirectory()
    )
      return;

    const controller = new AbortController();
    void (async () => {
      for await (const event of ctx.event.subscribe({
        signal: controller.signal,
      })) {
        if (
          event.location?.directory !== ctx.location.directory ||
          ("workspaceID" in event.location
            ? event.location.workspaceID
            : undefined) !== ctx.location.workspaceID
        )
          continue;

        try {
          if (event.type === "form.created") {
            await run("notify-send", ["opencode: question asked"]);
          }

          if (event.type === "permission.asked") {
            await run("notify-send", [
              `opencode: permission asked: ${event.data.action}`,
            ]);
          }

          if (event.type === "session.idle") {
            const session = await ctx.session
              .get({ sessionID: event.data.sessionID })
              .catch(() => undefined);
            if (session?.parentID) continue; // NOTE: ignore subagent

            await run("notify-send", ["opencode: session completed"]);
          }
        } catch (error) {
          console.error(
            "notification plugin: failed to send notification",
            error,
          );
        }
      }
    })().catch((error) => {
      if (!controller.signal.aborted)
        console.error("notification plugin: event subscription failed", error);
    });

    return () => controller.abort();
  },
});
