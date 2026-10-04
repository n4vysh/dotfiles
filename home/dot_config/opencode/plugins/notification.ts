import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { Plugin } from "@opencode/plugin";

const run = promisify(execFile);

export default Plugin.define({
  id: "notification",
  async setup(ctx) {
    const controller = new AbortController();
    void (async () => {
      for await (const event of ctx.event.subscribe({
        signal: controller.signal,
      })) {
        if (
          event.type !== "session.execution.succeeded" &&
          (event.location?.directory !== ctx.location.directory ||
            (event.location && "workspaceID" in event.location
              ? event.location.workspaceID
              : undefined) !== ctx.location.workspaceID)
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

          if (event.type === "session.execution.succeeded") {
            const session = await ctx.session
              .get({ sessionID: event.data.sessionID })
              .catch(() => undefined);
            if (
              !session ||
              session.location.directory !== ctx.location.directory ||
              ("workspaceID" in session.location
                ? session.location.workspaceID
                : undefined) !== ctx.location.workspaceID
            )
              continue;
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
