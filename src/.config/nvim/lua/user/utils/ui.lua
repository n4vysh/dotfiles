local M = {}

function M.open_package_manager()
	vim.ui.select({ "Plugins", "Tools", "MCP servers" }, {
		prompt = "Select Plugins / Tools / MCP servers",
	}, function(choice)
		if choice == "Plugins" then
			require("lazy").home()
		elseif choice == "Tools" then
			vim.cmd.Mason()
		elseif choice == "MCP servers" then
			vim.cmd.MCPHub()
		else
			do
			end
		end
	end)
end

return M
