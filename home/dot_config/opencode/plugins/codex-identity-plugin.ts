// NOTE: fix model not found error of GPT-5.6 Luna
//       this plugin is temporary workaround
// https://github.com/anomalyco/opencode/issues/36140#issuecomment-4938981436
import type { Plugin } from "@opencode-ai/plugin";

export default (async () => ({
  "chat.headers": async (input, output) => {
    if (
      !(
        input.model.providerID === "openai" && input.model.id === "gpt-5.6-luna"
      )
    )
      return;

    output.headers.originator = "codex_cli_rs";
    output.headers["User-Agent"] = "codex_cli_rs/0.0.0 (OpenCode)";
  },
})) satisfies Plugin;
