-- Browser Integration
return {
	{
		"tyru/open-browser.vim",
		keys = {
			{
				"gx",
				"<Plug>(openbrowser-smart-search)",
				mode = { "n", "v" },
				silent = true,
			},
		},
		init = function()
			vim.g.openbrowser_search_engines = {
				duckduckgo = "https://duckduckgo.com/?q={query}&kl=us-en&kp=1&k1=-1",
			}
			vim.g.openbrowser_default_search = "duckduckgo"
		end,
	},
	{
		"axieax/urlview.nvim",
		keys = {
			{
				"<space>su",
				"<cmd>UrlView buffer<cr>",
				silent = true,
				desc = "Search for URLs",
			},
			{ "[u" },
			{ "]u" },
		},
		opts = { default_picker = "telescope" },
	},
}
