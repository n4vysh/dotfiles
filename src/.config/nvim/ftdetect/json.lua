do
	local auname = "waybar"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = auname,
		pattern = "*/.config/waybar/config",
		callback = function()
			vim.opt_local.filetype = "json"
		end,
	})
end
