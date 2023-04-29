do
	local auname = "neofetch"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = auname,
		pattern = "*/.config/neofetch/config",
		callback = function()
			vim.opt_local.filetype = "bash"
		end,
	})
end
