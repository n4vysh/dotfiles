import type { Plugin } from "@opencode-ai/plugin";

export const NotificationPlugin: Plugin = async ({ client, $, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "permission.asked") {
        const perm = event.properties;
        await $`notify-send 'opencode: Permission asked: ${perm.permission}'`;
      }

      if (event.type === "session.idle") {
        const session = await client.session
          .get({
            sessionID: event.properties.sessionID,
            directory,
          })
          .catch(() => undefined);
        if (session?.data?.parentID) return; // NOTE: ignore subagent

        await $`notify-send 'opencode: session completed'`;
      }
    },
  };
};
