/** @type {import('stylelint').Config} */
import { resolve } from "node:path";
import { homedir } from "node:os";

export default {
  extends: resolve(
    homedir(),
    ".local/share/mise/installs/npm-stylelint-config-standard/40.0.0/node_modules/stylelint-config-standard",
  ),
};
