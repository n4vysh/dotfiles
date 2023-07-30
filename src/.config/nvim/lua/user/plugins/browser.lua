-- Browser Integration
return {
	{
		"tyru/open-browser.vim",
		keys = {
			{ "gx", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" }, silent = true },
		},
		init = function()
			vim.g.netrw_nogx = 1
		end,
	},
}
