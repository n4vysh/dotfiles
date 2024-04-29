return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		build = function()
			vim.cmd.TSUpdate()
		end,
		init = function()
			vim.g.matchup_matchparen_offscreen = {
				scrolloff = 1,
			}

			vim.treesitter.language.register("python", "tiltfile")
		end,
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"comment",
				"css",
				"diff",
				"dockerfile",
				"fish",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"graphql",
				"hcl",
				"ini",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"mermaid",
				"passwd",
				"proto",
				"python",
				"regex",
				"rego",
				"sql",
				"ssh_config",
				"terraform",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
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
						["]m"] = { query = "@function.outer", desc = "Next function start" },
						["]]"] = { query = "@class.outer", desc = "Next class start" },
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope start" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
						["]k"] = { query = "@block.outer", desc = "Next block start" },
						["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
						["]o"] = { query = "@loop.outer", desc = "Next loop start" },
						["]v"] = { query = "@assignment.outer", desc = "Next variable start" },
						["]?"] = { query = "@conditional.outer", desc = "Next conditional start" },
					},
					goto_next_end = {
						["]M"] = { query = "@function.outer", desc = "Next function end" },
						["]["] = { query = "@class.outer", desc = "Next class end" },
						["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope end" },
						["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold end" },
						["]K"] = { query = "@block.outer", desc = "Next block end" },
						["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
						["]O"] = { query = "@loop.outer", desc = "Next loop end" },
						["]V"] = { query = "@assignment.outer", desc = "Next variable end" },
					},
					goto_previous_start = {
						["[m"] = { query = "@function.outer", desc = "Previous function start" },
						["[["] = { query = "@class.outer", desc = "Previous class start" },
						["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
						["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
						["[k"] = { query = "@block.outer", desc = "Previous block start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
						["[o"] = { query = "@loop.outer", desc = "Previous loop start" },
						["[v"] = { query = "@assignment.outer", desc = "Previous variable start" },
						["[?"] = { query = "@conditional.outer", desc = "Previous conditional start" },
					},
					goto_previous_end = {
						["[M"] = { query = "@function.outer", desc = "Previous function end" },
						["[]"] = { query = "@class.outer", desc = "Previous class end" },
						["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope end" },
						["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold end" },
						["[K"] = { query = "@block.outer", desc = "Previous block end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
						["[O"] = { query = "@loop.outer", desc = "Previous loop end" },
						["[V"] = { query = "@assignment.outer", desc = "Previous variable end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">k"] = { query = "@block.outer", desc = "Swap next block" },
						[">f"] = { query = "@function.outer", desc = "Swap next function" },
						[">a"] = { query = "@parameter.inner", desc = "Swap next argument" },
					},
					swap_previous = {
						["<k"] = { query = "@block.outer", desc = "Swap previous block" },
						["<f"] = { query = "@function.outer", desc = "Swap previous function" },
						["<a"] = { query = "@parameter.inner", desc = "Swap previous argument" },
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
			autotag = {
				enable = true,
			},
			endwise = {
				enable = true,
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-endwise",
			"andymass/vim-matchup",
			"windwp/nvim-ts-autotag",
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				main = "ts_context_commentstring",
				ops = {
					enable_autocmd = false,
				},
			},
		},
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
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				{ desc = "Jump next todo comment" },
			},
			{
				"[t",
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
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			require("rainbow-delimiters.setup").setup({
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
			})
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
}
