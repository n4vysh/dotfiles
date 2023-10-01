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
	{
		"axieax/urlview.nvim",
		keys = {
			{ "<space>su", "<cmd>UrlView buffer bufnr=0<cr>", silent = true, desc = "Search for URLs" },
			{ "[u" },
			{ "]u" },
		},
		opts = { default_picker = "telescope" },
	},
}
