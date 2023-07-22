do
	local auname = "neofetch"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = auname,
		pattern = { "/var/tmp/passwd.*", "/var/tmp/shadow.*" },
		callback = function()
			vim.opt_local.filetype = "passwd"
		end,
	})
end
