do
	local augroup = "waybar"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = "*/.config/waybar/config",
		callback = function()
			vim.opt_local.filetype = "json"
		end,
	})
end
