do
	local augroup = "gitconfig"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = "*/.config/git/config.*",
		callback = function()
			vim.opt_local.filetype = "gitconfig"
		end,
	})
end
