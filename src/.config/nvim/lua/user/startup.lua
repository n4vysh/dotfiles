-- -- NOTE: remove directory buffer when startup
for _, v in ipairs(vim.fn.argv()) do
	if vim.fn.isdirectory(v) ~= 0 then
		local bufnr = vim.fn.bufnr(v)
		if bufnr ~= -1 then
			local success, result = pcall(function()
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end)
			if success then
				vim.notify(
					"Deleted directory from buffer list: "
						.. vim.fn.fnamemodify(v, ":.")
						.. "\n",
					vim.log.levels.WARN
				)
			else
				vim.notify(
					"Failed to delete buffer for: "
						.. v
						.. ". Error: "
						.. tostring(result),
					vim.log.levels.ERROR
				)
			end
		end
	end
end
