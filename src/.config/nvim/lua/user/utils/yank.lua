local M = {}

function M.exec(key, value)
	vim.fn.setreg("+", value)
	print(string.format("Yanked %s to system clipboard", key))
end

return M
