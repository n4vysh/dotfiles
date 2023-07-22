return {
	{
		"nvim-treesitter/nvim-treesitter",
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
					"git_rebase",
					"gitattributes",
					"gitignore",
					"go",
					"gomod",
					"graphql",
					"hcl",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"regex",
					"rego",
					"rust",
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
							["iC"] = "@conditional.inner",
							["aC"] = "@conditional.outer",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aL"] = "@loop.outer",
							["iL"] = "@loop.inner",
						},
					},
				},
				move = {
					enable = true,
					set_jumps = false,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = { query = "@class.outer", desc = "Next class start" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
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
		config = function()
			require("hlargs").setup()
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"itchyny/vim-highlighturl",
	},
	{
		"folke/todo-comments.nvim",
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
}
