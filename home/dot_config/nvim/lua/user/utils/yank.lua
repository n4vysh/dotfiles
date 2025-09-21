local M = {}

function M.exec(key, value)
	vim.fn.setreg("+", value)
	vim.notify(
		string.format("Yanked %s to system clipboard", key),
		vim.log.levels.INFO
	)
end

return M
