require("user.plugin")
require("user.options")
require("user.autocmds")
require("user.keymaps")
if pcall(require, "user.local") then
	require("user.local")
end
