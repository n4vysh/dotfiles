do
	local augroup = "tftest"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = { "*.tftest.hcl" },
		callback = function()
			-- NOTE: Set filetype for none-ls terraform_fmt source
			vim.opt_local.filetype = "terraform"
			vim.opt_local.syntax = "hcl"
			vim.diagnostic.enable(false)
		end,
	})
end
