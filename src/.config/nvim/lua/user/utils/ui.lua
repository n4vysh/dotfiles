local M = {}

function M.select_plugin_or_package_manager()
	vim.ui.select({ "plugin manager", "package manager" }, {
		prompt = "Select plugin / package manager",
	}, function(choice)
		if choice == nil then
			do
			end
		elseif choice == "plugin manager" then
			require("lazy").home()
		else
			vim.cmd.Mason()
		end
	end)
end

return M
