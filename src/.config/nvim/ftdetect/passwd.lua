do
	local augroup = "passwd"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = { "/var/tmp/passwd.*", "/var/tmp/shadow.*" },
		callback = function()
			vim.opt_local.filetype = "passwd"
		end,
	})
end
