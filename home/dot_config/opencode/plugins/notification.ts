import type { Plugin } from "@opencode-ai/plugin";

export const NotificationPlugin: Plugin = async ({ client, $, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "question.asked") {
        await $`notify-send 'opencode: Question asked'`;
      }

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

        // NOTE: ignore subagent
        if (!session?.data || session.data.parentID) return;

        await $`notify-send 'opencode: session completed'`;
      }
    },
  };
};
