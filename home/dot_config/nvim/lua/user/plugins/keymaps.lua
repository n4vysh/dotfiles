return {
	{
		"tpope/vim-unimpaired",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = function()
			-- remove keymap for urlview.nvim
			vim.cmd("silent! xunmap [uu")
			vim.cmd("silent! xunmap ]uu")
			vim.cmd("silent! nunmap [uu")
			vim.cmd("silent! nunmap ]uu")
			vim.cmd("silent! xunmap [uU")
			vim.cmd("silent! xunmap ]uU")
			vim.cmd("silent! nunmap [uU")
			vim.cmd("silent! nunmap ]uU")
		end,
	},
	{
		"tpope/vim-rsi",
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"folke/which-key.nvim",
		event = { "VeryLazy" },
		opts = {
			preset = "helix",
			plugins = {
				marks = false,
				registers = true,
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				},
			},
			triggers = {
				{ " ", mode = { "n", "x" } },
			},
			icons = {
				rules = false,
			},
			spec = {
				{ "<space>a", group = "ai", icon = "", mode = { "n", "x" } },
				{ "<space>b", group = "buffer", icon = "󰓩" },
				{
					"<space>c",
					group = "command",
					icon = "",
					mode = { "n", "x" },
				},
				{ "<space>d", group = "debug", icon = "󰃤" },
				{ "<space>e", group = "edit", icon = "" },
				{
					"<space>f",
					group = "file",
					icon = "󰈔",
					mode = { "n", "x" },
				},
				{ "<space>l", group = "lang", icon = "" },
				{ "<space>m", group = "mark", icon = "" },
				{ "<space>n", group = "notify", icon = "" },
				{ "<space>p", group = "package", icon = "" },
				{
					"<space>r",
					group = "refactor",
					icon = "",
					mode = { "n", "x" },
				},
				{ "<space>re", group = "extract" },
				{ "<space>ri", group = "inline" },
				{
					"<space>s",
					group = "search",
					icon = "",
					mode = { "n", "x" },
				},
				{ "<space>t", group = "test", icon = "󰙨" },
				{ "<space>tc", group = "coverage" },
				{
					"<space>v",
					group = "version",
					icon = "",
					mode = { "n", "x" },
				},
				{ "<space>y", group = "yank", icon = "" },
			},
		},
	},
}
