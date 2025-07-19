do
	local augroup = "tilt"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = { "Tiltfile" },
		callback = function()
			-- NOTE: Set filetype for Tilt language server
			vim.opt_local.filetype = "tiltfile"
			vim.opt_local.syntax = "python"
		end,
	})
end
