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
				"passwd",
				"proto",
				"regex",
				"rego",
				"sql",
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
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = { query = "@function.outer", desc = "Next function start" },
						["]]"] = { query = "@class.outer", desc = "Next class start" },
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = { query = "@function.outer", desc = "Next function end" },
						["]["] = { query = "@class.outer", desc = "Next class end" },
					},
					goto_previous_start = {
						["[m"] = { query = "@function.outer", desc = "Previous function start" },
						["[["] = { query = "@class.outer", desc = "Previous class start" },
						["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
						["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
					},
					goto_previous_end = {
						["[M"] = { query = "@function.outer", desc = "Previous function end" },
						["[]"] = { query = "@class.outer", desc = "Previous class end" },
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
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
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
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
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
