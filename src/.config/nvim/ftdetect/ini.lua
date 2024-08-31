do
	local augroup = "swappy"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = "*/.config/swappy/config",
		callback = function()
			vim.opt_local.filetype = "ini"
		end,
	})
end
