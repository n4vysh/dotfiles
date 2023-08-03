return {
	{
		"tpope/vim-unimpaired",
		event = { "VeryLazy" },
	},
	{
		"echasnovski/mini.bracketed",
		event = { "VeryLazy" },
		version = "*",
		config = function()
			-- remove keymap of vim-unimpaired
			vim.cmd("silent! xunmap [n")
			vim.cmd("silent! xunmap ]n")
			vim.cmd("silent! nunmap [n")
			vim.cmd("silent! nunmap ]n")
			vim.cmd("silent! xunmap [x")
			vim.cmd("silent! xunmap ]x")
			vim.cmd("silent! nunmap [x")
			vim.cmd("silent! nunmap ]x")
			vim.cmd("silent! nunmap [xx")
			vim.cmd("silent! nunmap ]xx")
			vim.cmd("silent! xunmap [y")
			vim.cmd("silent! xunmap ]y")
			vim.cmd("silent! nunmap [yy")
			vim.cmd("silent! nunmap ]yy")
			require("mini.bracketed").setup({
				buffer = { suffix = "", options = {} },
				comment = { suffix = "k", options = {} },
				conflict = { suffix = "x", options = {} },
				diagnostic = { suffix = "", options = {} },
				file = { suffix = "", options = {} },
				indent = { suffix = "i", options = { change_type = "diff" } },
				jump = { suffix = "j", options = {} },
				location = { suffix = "", options = {} },
				oldfile = { suffix = "", options = {} },
				quickfix = { suffix = "", options = {} },
				treesitter = { suffix = "", options = {} },
				undo = { suffix = "", options = {} },
				window = { suffix = "", options = {} },
				yank = { suffix = "y", options = {} },
			})
		end,
	},
	{
		"tpope/vim-rsi",
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"folke/which-key.nvim",
		keys = {
			{ "<C-_>", "<cmd>WhichKey \\<space><cr>", desc = "Show custom keymaps" },
			{ "g<C-_>", "<cmd>WhichKey<cr>", desc = "Show all custom keymaps" },
		},
		config = function()
			require("which-key").setup({
				plugins = {
					marks = false,
					registers = false,
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
				triggers = "manual",
			})
			local wk = require("which-key")
			wk.register({
				["<space>"] = {
					a = { name = "+alternate" },
					b = { name = "+buffer" },
					c = { name = "+command" },
					d = { name = "+debug" },
					e = { name = "+edit" },
					f = { name = "+file" },
					l = { name = "+lang" },
					m = { name = "+mark" },
					p = { name = "+package" },
					r = { name = "+refactor" },
					s = { name = "+search" },
					t = { name = "+test" },
					v = { name = "+version" },
					y = { name = "+yank" },
				},
			})
		end,
	},
}
