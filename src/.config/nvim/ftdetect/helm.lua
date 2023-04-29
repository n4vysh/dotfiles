do
	local auname = "helm"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = auname,
		pattern = "*/helmfiles/*.yaml,helmfile.yaml",
		callback = function()
			vim.opt_local.filetype = "helm"
		end,
	})
end
