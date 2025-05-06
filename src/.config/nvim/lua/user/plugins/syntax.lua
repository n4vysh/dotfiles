return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre" },
		cmd = {
			"TSInstall",
			"TSInstallSync",
			"TSInstallInfo",
			"TSUpdate",
			"TSUpdateSync",
			"TSUninstall",
			"TSBufEnable",
			"TSBufDisable",
			"TSBufToggle",
			"TSEnable",
			"TSDisable",
			"TSToggle",
			"TSModuleInfo",
			"TSEditQuery",
			"TSEditQueryUserAfter",
		},
		build = function()
			vim.cmd.TSUpdate()
		end,
		init = function()
			vim.treesitter.language.register("python", "tiltfile")
		end,
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
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
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = "<C-k>",
					node_decremental = "<C-l>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						["ak"] = "@block.outer",
						["ik"] = "@block.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ao"] = "@loop.outer",
						["io"] = "@loop.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["a?"] = "@conditional.outer",
						["i?"] = "@conditional.inner",
						["av"] = "@assignment.outer",
						["iv"] = "@assignment.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = {
							query = "@function.outer",
							desc = "Next function start",
						},
						["]]"] = {
							query = "@class.outer",
							desc = "Next class start",
						},
						["]s"] = {
							query = "@scope",
							query_group = "locals",
							desc = "Next scope start",
						},
						["]z"] = {
							query = "@fold",
							query_group = "folds",
							desc = "Next fold start",
						},
						["]k"] = {
							query = "@block.outer",
							desc = "Next block start",
						},
						["]a"] = {
							query = "@parameter.inner",
							desc = "Next parameter start",
						},
						["]o"] = {
							query = "@loop.outer",
							desc = "Next loop start",
						},
						["]v"] = {
							query = "@assignment.outer",
							desc = "Next variable start",
						},
						["]?"] = {
							query = "@conditional.outer",
							desc = "Next conditional start",
						},
					},
					goto_next_end = {
						["]M"] = {
							query = "@function.outer",
							desc = "Next function end",
						},
						["]["] = {
							query = "@class.outer",
							desc = "Next class end",
						},
						["]S"] = {
							query = "@scope",
							query_group = "locals",
							desc = "Next scope end",
						},
						["]Z"] = {
							query = "@fold",
							query_group = "folds",
							desc = "Next fold end",
						},
						["]K"] = {
							query = "@block.outer",
							desc = "Next block end",
						},
						["]A"] = {
							query = "@parameter.inner",
							desc = "Next parameter end",
						},
						["]O"] = {
							query = "@loop.outer",
							desc = "Next loop end",
						},
						["]V"] = {
							query = "@assignment.outer",
							desc = "Next variable end",
						},
					},
					goto_previous_start = {
						["[m"] = {
							query = "@function.outer",
							desc = "Previous function start",
						},
						["[["] = {
							query = "@class.outer",
							desc = "Previous class start",
						},
						["[s"] = {
							query = "@scope",
							query_group = "locals",
							desc = "Previous scope",
						},
						["[z"] = {
							query = "@fold",
							query_group = "folds",
							desc = "Previous fold",
						},
						["[k"] = {
							query = "@block.outer",
							desc = "Previous block start",
						},
						["[a"] = {
							query = "@parameter.inner",
							desc = "Previous parameter start",
						},
						["[o"] = {
							query = "@loop.outer",
							desc = "Previous loop start",
						},
						["[v"] = {
							query = "@assignment.outer",
							desc = "Previous variable start",
						},
						["[?"] = {
							query = "@conditional.outer",
							desc = "Previous conditional start",
						},
					},
					goto_previous_end = {
						["[M"] = {
							query = "@function.outer",
							desc = "Previous function end",
						},
						["[]"] = {
							query = "@class.outer",
							desc = "Previous class end",
						},
						["[S"] = {
							query = "@scope",
							query_group = "locals",
							desc = "Previous scope end",
						},
						["[Z"] = {
							query = "@fold",
							query_group = "folds",
							desc = "Previous fold end",
						},
						["[K"] = {
							query = "@block.outer",
							desc = "Previous block end",
						},
						["[A"] = {
							query = "@parameter.inner",
							desc = "Previous parameter end",
						},
						["[O"] = {
							query = "@loop.outer",
							desc = "Previous loop end",
						},
						["[V"] = {
							query = "@assignment.outer",
							desc = "Previous variable end",
						},
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">k"] = {
							query = "@block.outer",
							desc = "Swap next block",
						},
						[">f"] = {
							query = "@function.outer",
							desc = "Swap next function",
						},
						[">a"] = {
							query = "@parameter.inner",
							desc = "Swap next argument",
						},
					},
					swap_previous = {
						["<k"] = {
							query = "@block.outer",
							desc = "Swap previous block",
						},
						["<f"] = {
							query = "@function.outer",
							desc = "Swap previous function",
						},
						["<a"] = {
							query = "@parameter.inner",
							desc = "Swap previous argument",
						},
					},
				},
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			matchup = {
				enable = true,
			},
			endwise = {
				enable = true,
			},
		},
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {},
			},
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-endwise",
			{
				"andymass/vim-matchup",
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
						"gm",
						"<plug>(matchup-g%)",
						{
							silent = true,
							desc = "Goto backword to matching word",
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
					{
						mode = { "n" },
						"dzm",
						"<plug>(matchup-ds%)",
						{
							silent = true,
							desc = "Delete surrounding matching words",
						},
					},
					{
						mode = { "n" },
						"czm",
						"<plug>(matchup-cs%)",
						{
							silent = true,
							desc = "Change surrounding matching words",
						},
					},
				},
				init = function()
					vim.g.matchup_surround_enabled = 1

					vim.g.matchup_matchparen_offscreen = {
						scrolloff = 1,
					}
				end,
			},
		},
	},
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
		ft = "ghostty",
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
