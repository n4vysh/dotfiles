do
	local augroup = "neofetch"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = "*/.config/neofetch/config",
		callback = function()
			vim.opt_local.filetype = "bash"
		end,
	})
end
