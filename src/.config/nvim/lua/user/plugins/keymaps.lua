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
			-- remove keymap for mini.bracketed
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
			-- remove keymap for nvim-treesitter-textobjects
			vim.cmd("silent! nunmap [o")
			vim.cmd("silent! nunmap ]o")
			vim.cmd("silent! nunmap [o<Esc>")
			vim.cmd("silent! nunmap ]o<Esc>")
		end,
	},
	{
		"echasnovski/mini.bracketed",
		version = "*",
		keys = {
			{ "[k" },
			{ "]k" },
			{ "[x" },
			{ "]x" },
			{ "[i" },
			{ "]i" },
			{ "[j" },
			{ "]j" },
			{ "[y" },
			{ "]y" },
		},
		opts = {
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
		},
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
					a = { name = "+ai/alternate" },
					b = { name = "+buffer" },
					c = { name = "+command" },
					d = { name = "+debug" },
					e = { name = "+edit" },
					f = { name = "+file" },
					l = { name = "+lang" },
					m = { name = "+mark" },
					p = { name = "+package" },
					r = {
						name = "+refactor",
						e = {
							name = "+extract",
						},
						i = {
							name = "+inline",
						},
					},
					s = { name = "+search" },
					t = {
						name = "+test",
						c = {
							name = "+coverage",
						},
					},
					v = { name = "+version" },
					y = { name = "+yank" },
				},
			})
		end,
	},
}
