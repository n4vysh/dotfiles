import type { Plugin } from "@opencode-ai/plugin";

export const NotificationPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`notify-send 'opencode: session completed'`;
      }
    },
  };
};
