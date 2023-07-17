-- HACK: avoid E5248
-- https://github.com/neovim/nvim-lspconfig/issues/2685
do
	local auname = "terraform"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = auname,
		pattern = "*.tfvars",
		callback = function()
			vim.opt_local.filetype = "terraform"
		end,
	})
end
