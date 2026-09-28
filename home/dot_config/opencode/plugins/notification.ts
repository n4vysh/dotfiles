import type { Plugin } from "@opencode-ai/plugin";

export const NotificationPlugin: Plugin = async ({ client, $, directory }) => {
  return {
    event: async ({ event }) => {
      // NOTE: disable when running nono sandbox on WSL
      //       nono not support plan9 (pwsh.exe and BurntToast)
      if (
        (await $`printenv NONO_CAP_FILE`.quiet().nothrow()).exitCode === 0 &&
        (await $`test -d /mnt/wsl`.nothrow()).exitCode === 0
      )
        return;

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
        if (session?.data?.parentID) return; // NOTE: ignore subagent

        await $`notify-send 'opencode: session completed'`;
      }
    },
  };
};
