return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false, -- nvim-treesitter not support lazy-loading
		branch = "main",
		build = function()
			vim.cmd.TSUpdate()
		end,
		init = function()
			vim.treesitter.language.register("python", "tiltfile")

			do
				local augroup = "treesitter"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = augroup,
					pattern = "*",
					callback = function()
						pcall(vim.treesitter.start)
					end,
				})
			end

			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"comment",
				"css",
				"csv",
				"diff",
				"dockerfile",
				"editorconfig",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"gpg",
				"graphql",
				"hcl",
				"helm",
				"html",
				"hyprlang",
				"ini",
				"javascript",
				"json",
				"jsonnet",
				"just",
				"lua",
				"luap",
				"make",
				"markdown",
				"markdown_inline",
				"mermaid",
				"nginx",
				"nix",
				"passwd",
				"printf",
				"promql",
				"proto",
				"python",
				"query",
				"rasi",
				"regex",
				"rego",
				"robots",
				"sql",
				"ssh_config",
				"styled",
				"terraform",
				"toml",
				"tsx",
				"typescript",
				"udev",
				"vhs",
				"vim",
				"vimdoc",
				"yaml",
			})
		end,
	},
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
		ft = "ghostty",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		keys = {
			-- select
			{
				mode = { "x", "o" },
				"ak",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@block.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @block.outer",
				},
			},
			{
				mode = { "x", "o" },
				"ik",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@block.inner",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @block.inner",
				},
			},
			{
				mode = { "x", "o" },
				"aa",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@parameter.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @parameter.outer",
				},
			},
			{
				mode = { "x", "o" },
				"ia",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@parameter.inner",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @parameter.inner",
				},
			},
			{
				mode = { "x", "o" },
				"af",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@function.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @function.outer",
				},
			},
			{
				mode = { "x", "o" },
				"if",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@function.inner",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @function.inner",
				},
			},
			{
				mode = { "x", "o" },
				"av",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@assignment.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @assignment.outer",
				},
			},
			{
				mode = { "x", "o" },
				"iv",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@assignment.inner",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Select textobject @assignment.inner",
				},
			},
			-- move
			{
				mode = { "n", "x", "o" },
				"]m",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@function.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Next function start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"[m",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@function.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Previous function start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"]]",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@block.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Next block start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"[[",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@block.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Previous block start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"]a",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@parameter.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Next parameter start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"[a",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@parameter.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Previous parameter start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"]v",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@assignment.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Next assignment start",
				},
			},
			{
				mode = { "n", "x", "o" },
				"[v",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@assignment.outer",
						"textobjects"
					)
				end,
				{
					silent = true,
					desc = "Previous assignment start",
				},
			},
			-- swap
			{
				">a",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next(
						"@parameter.inner"
					)
				end,
				{
					silent = true,
					desc = "Swap next argument",
				},
			},
			{
				"<a",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous(
						"@parameter.outer"
					)
				end,
				{
					silent = true,
					desc = "Swap previous argument",
				},
			},
		},
		opts = {
			move = {
				set_jumps = true,
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"RRethy/nvim-treesitter-endwise",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"andymass/vim-matchup",
		lazy = false, -- vim-matchup not support lazy-loading
		keys = {
			{
				mode = { "n", "x", "o" },
				"m",
				"<plug>(matchup-%)",
				{
					silent = true,
					desc = "Goto forward to matching word",
				},
			},
			{
				mode = { "n", "x", "o" },
				"zm",
				"<plug>(matchup-z%)",
				{
					silent = true,
					desc = "Goto inside of matching word",
				},
			},
			{
				mode = { "n", "x", "o" },
				"]w",
				"<plug>(matchup-]%)",
				{
					silent = true,
					desc = "Goto previous outer open word",
				},
			},
			{
				mode = { "n", "x", "o" },
				"[w",
				"<plug>(matchup-[%)",
				{
					silent = true,
					desc = "Goto next surrounding close word",
				},
			},
			{
				mode = { "x", "o" },
				"im",
				"<plug>(matchup-i%)",
				{
					silent = true,
					desc = "Inside of matching word",
				},
			},
			{
				mode = { "x", "o" },
				"am",
				"<plug>(matchup-a%)",
				{
					silent = true,
					desc = "Around of matching word",
				},
			},
		},
		opts = {
			matchparen = {
				offscreen = {
					scrolloff = 1,
				},
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		main = "ts_context_commentstring",
		ops = {
			enable_autocmd = false,
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"m-demare/hlargs.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"itchyny/vim-highlighturl",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{
				"]<C-t>",
				function()
					require("todo-comments").jump_next()
				end,
				{ desc = "Jump next todo comment" },
			},
			{
				"[<C-t>",
				function()
					require("todo-comments").jump_prev()
				end,
				{ desc = "Jump previous todo comment" },
			},
		},
		opts = {},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		main = "rainbow-delimiters.setup",
		opts = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			return {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
}
