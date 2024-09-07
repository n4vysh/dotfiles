do
	local augroup = "yamllint"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = "*/.config/yamllint/config",
		callback = function()
			vim.opt_local.filetype = "yaml"
		end,
	})
end
