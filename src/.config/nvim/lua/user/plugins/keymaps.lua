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
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{
				"<C-_>",
				function()
					require("which-key").show({ keys = "<space>" })
				end,
				desc = "Show custom keymaps",
			},
			{
				"g<C-_>",
				function()
					require("which-key").show()
				end,
				desc = "Show all custom keymaps",
			},
		},
		opts = {
			preset = "modern",
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
			triggers = {
				{ "<C-_>", mode = { "n" } },
				{ "g<C-_>", mode = { "n" } },
			},
			icons = {
				rules = false,
			},
			spec = {
				{ "<space>a", group = "ai/alternate" },
				{ "<space>b", group = "buffer" },
				{ "<space>c", group = "command" },
				{ "<space>d", group = "debug" },
				{ "<space>e", group = "edit" },
				{ "<space>f", group = "file" },
				{ "<space>l", group = "lang" },
				{ "<space>m", group = "mark" },
				{ "<space>n", group = "notify" },
				{ "<space>p", group = "package" },
				{ "<space>r", group = "refactor" },
				{ "<space>re", group = "extract" },
				{ "<space>ri", group = "inline" },
				{ "<space>s", group = "search" },
				{ "<space>t", group = "test" },
				{ "<space>tc", group = "coverage" },
				{ "<space>v", group = "version" },
				{ "<space>y", group = "yank" },
			},
		},
	},
}
