return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "VeryLazy" },
		build = function()
			vim.cmd.TSUpdate()
		end,
		init = function()
			vim.g.matchup_matchparen_offscreen = {
				scrolloff = 1,
			}
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
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
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-endwise",
			"andymass/vim-matchup",
			"windwp/nvim-ts-autotag",
			{
				"numToStr/Comment.nvim",
				config = function()
					require("Comment").setup({
						pre_hook = function(ctx)
							local U = require("Comment.utils")

							local location = nil
							if ctx.ctype == U.ctype.block then
								location = require("ts_context_commentstring.utils").get_cursor_location()
							elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
								location = require("ts_context_commentstring.utils").get_visual_start_location()
							end

							return require("ts_context_commentstring.internal").calculate_commentstring({
								key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
								location = location,
							})
						end,
					})
				end,
				dependencies = {
					"JoosepAlviste/nvim-ts-context-commentstring",
				},
			},
		},
	},
	{
		"m-demare/hlargs.nvim",
		event = { "VeryLazy" },
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"itchyny/vim-highlighturl",
	},
	{
		"folke/todo-comments.nvim",
		event = { "VeryLazy" },
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})

			vim.keymap.set("n", "]t", function()
				require("todo-comments").jump_next()
			end, { desc = "Jump next todo comment" })

			vim.keymap.set("n", "[t", function()
				require("todo-comments").jump_prev()
			end, { desc = "Jump previous todo comment" })
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
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
	},
}
