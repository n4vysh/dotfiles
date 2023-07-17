return {
	{
		"tpope/vim-abolish",
		config = function()
			vim.opt.iskeyword:append({ "-" })
		end,
	},
	{ "inkarkat/vim-ReplaceWithRegister" },
	{
		"tommcdo/vim-exchange",
		init = function()
			vim.g.exchange_no_mappings = 1
		end,
		config = function()
			-- HACK: change keymap to avoid conflict for leap.nvim
			-- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
			vim.keymap.set({ "n" }, "cx", "<Plug>(Exchange)", {
				silent = true,
			})
			vim.keymap.set({ "x" }, "gX", "<Plug>(Exchange)", {
				silent = true,
			})
			vim.keymap.set({ "n" }, "cxc", "<Plug>(ExchangeClear)", {
				silent = true,
			})
			vim.keymap.set({ "n" }, "cxx", "<Plug>(ExchangeLine)", {
				silent = true,
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		config = function()
			vim.keymap.set("n", "<space>sr", require("spectre").open, {
				desc = "Search and replace",
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"cshuaimin/ssr.nvim",
		config = function()
			require("ssr").setup({})
			vim.keymap.set({ "n", "x" }, "<space>s<C-r>", require("ssr").open, {
				desc = "Structural search and replace",
			})
		end,
	},
	{
		"fedepujol/move.nvim",
		config = function()
			local opts = { silent = true }

			vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
			vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
			vim.keymap.set("n", "<A-h>", ":MoveHChar(-1)<CR>", opts)
			vim.keymap.set("n", "<A-l>", ":MoveHChar(1)<CR>", opts)

			vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
			vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
			vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
			vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)
		end,
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, desc = "Align text" },
		},
	},
	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_theme = "neon"
			vim.g.VM_silent_exit = 1
			vim.g.VM_set_statusline = 0
			-- disable backspace mapping for autopairs
			-- https://github.com/mg979/vim-visual-multi/issues/172#issuecomment-1092293500
			vim.g.VM_maps = {
				["I BS"] = "",
			}
		end,
	},
	{
		"kana/vim-textobj-entire",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-datetime",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"adolenc/vim-textobj-toplevel",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"mattn/vim-textobj-url",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"pianohacker/vim-textobj-indented-paragraph",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-indent",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"glts/vim-textobj-indblock",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"glts/vim-textobj-comment",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"rsrchboy/vim-textobj-heredocs",
		dependencies = "kana/vim-textobj-user",
	},
	{
		"coachshea/vim-textobj-markdown",
		dependencies = {
			"kana/vim-textobj-user",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			do
				local auname = "vim_textobj_markdown"
				vim.api.nvim_create_augroup(auname, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = auname,
					pattern = { "markdown" },
					callback = function()
						-- remove keymap of nvim-treesitter-textobjects
						vim.cmd([[silent! ounmap <buffer> af]])
						vim.cmd([[silent! ounmap <buffer> if]])
						vim.cmd([[silent! ounmap <buffer> aF]])
						vim.cmd([[silent! ounmap <buffer> iF]])
						vim.cmd([[silent! xunmap <buffer> af]])
						vim.cmd([[silent! xunmap <buffer> if]])
						vim.cmd([[silent! xunmap <buffer> aF]])
						vim.cmd([[silent! xunmap <buffer> iF]])
						-- remap for vim-textobj-markdown
						-- https://github.com/coachshea/vim-textobj-markdown/blob/master/README.md#conflicts-with-other-plugins
						vim.keymap.set({ "o", "x" }, "af", "<plug>(textobj-markdown-chunk-a)", {
							silent = true,
							desc = "around the current fence",
						})
						vim.keymap.set({ "o", "x" }, "if", "<plug>(textobj-markdown-chunk-i)", {
							silent = true,
							desc = "inside the current fence",
						})
						vim.keymap.set({ "o", "x" }, "aF", "<plug>(textobj-markdown-Bchunk-a)", {
							silent = true,
							desc = "around the backward fence",
						})
						vim.keymap.set({ "o", "x" }, "iF", "<plug>(textobj-markdown-Bchunk-i)", {
							silent = true,
							desc = "inside the backward fence",
						})
					end,
				})
			end
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"danymat/neogen",
		config = function()
			require("neogen").setup({
				snippet_engine = "luasnip",
			})

			vim.keymap.set("n", "gca", require("neogen").generate, {
				silent = true,
				desc = "Generate annotation",
			})
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{ "tpope/vim-repeat" },
	{
		"kylechui/nvim-surround",
		config = function()
			-- HACK: change keymap to avoid conflict for leap.nvim
			-- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
			require("nvim-surround").setup({
				keymaps = {
					visual = "gs",
					visual_line = "gS",
				},
			})
		end,
	},
	{ "wellle/targets.vim" },
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})

			vim.keymap.set("n", "gS", require("treesj").split, {
				desc = "Split node under cursor",
			})

			vim.keymap.set("n", "gJ", require("treesj").join, {
				desc = "Join node under cursor",
			})
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require("refactoring").setup({})

			vim.keymap.set("v", "<space>re", function()
				require("refactoring").refactor("Extract Function")
			end, { silent = true })

			vim.keymap.set("v", "<space>rf", function()
				require("refactoring").refactor("Extract Function To File")
			end, { silent = true })

			vim.keymap.set("v", "<space>rv", function()
				require("refactoring").refactor("Extract Variable")
			end, { silent = true })

			vim.keymap.set("v", "<space>ri", function()
				require("refactoring").refactor("Inline Variable")
			end, { silent = true })

			vim.keymap.set("n", "<space>rb", function()
				require("refactoring").refactor("Extract Block")
			end, { silent = true })

			vim.keymap.set("n", "<space>rbf", function()
				require("refactoring").refactor("Extract Block To File")
			end, { silent = true })

			vim.keymap.set("n", "<space>ri", function()
				require("refactoring").refactor("Inline Variable")
			end, { noremap = true, silent = true, expr = false })

			require("telescope").load_extension("refactoring")

			vim.keymap.set("v", "<space>rr", require("telescope").extensions.refactoring.refactors)

			vim.keymap.set("n", "<space>rp", function()
				require("refactoring").debug.printf({ below = false })
			end)

			vim.keymap.set("n", "<space>rv", function()
				require("refactoring").debug.print_var({ normal = true })
			end)

			vim.keymap.set("v", "<space>rv", require("refactoring").debug.print_var)

			vim.keymap.set("n", "<space>rc", require("refactoring").debug.cleanup)
		end,
	},
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.constant.alias.bool,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%m/%d"],
					augend.date.alias["%H:%M"],
					augend.constant.alias.ja_weekday,
					augend.semver.alias.semver,
					augend.constant.new({
						elements = { "and", "or" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "yes", "no" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "on", "off" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "left", "right" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "up", "down" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "==", "!=" },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "&&", "||" },
						word = false,
						cyclic = true,
					}),
					augend.misc.alias.markdown_header,
				},
				visual = {
					augend.integer.alias.decimal,
					augend.constant.alias.bool,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%m/%d"],
					augend.date.alias["%H:%M"],
					augend.constant.alias.ja_weekday,
					augend.semver.alias.semver,
					augend.constant.new({
						elements = { "and", "or" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "yes", "no" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "on", "off" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "left", "right" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "up", "down" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "==", "!=" },
						word = false,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "&&", "||" },
						word = false,
						cyclic = true,
					}),
					augend.misc.alias.markdown_header,
				},
			})

			vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), {
				desc = "Increment",
			})

			vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), {
				desc = "Decrement",
			})

			vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), {
				desc = "Increment",
			})

			vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), {
				desc = "Decrement",
			})

			vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), {
				desc = "Increment",
			})

			vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), {
				desc = "Decrement",
			})
		end,
	},
	{
		"smjonas/live-command.nvim",
		config = function()
			require("live-command").setup({
				commands = {
					Normal = { cmd = "normal" },
					Delete = { cmd = "delete" },
					Global = { cmd = "global" },
					Vglobal = { cmd = "vglobal" },
					Sort = { cmd = "sort" },
				},
			})

			vim.keymap.set("n", "<space>c<C-s>", ":%Sort ", {
				desc = "Set command for sort to command-line",
			})

			vim.keymap.set("v", "<space>c<C-s>", ":Sort ", {
				desc = "Set command for sort to command-line",
			})

			vim.keymap.set("n", "<space>cd", ":%Global//d<left><left>", {
				desc = "Set command for deleting line where pattern matches to command-line",
			})

			vim.keymap.set("v", "<space>cd", ":Global//d<left><left>", {
				desc = "Set command for deleting line where pattern matches to command-line",
			})

			vim.keymap.set("n", "<space>c<C-d>", ":%Vglobal//d<left><left>", {
				desc = "Set command for deleting line where pattern not matches to command-line",
			})

			vim.keymap.set("v", "<space>c<C-d>", ":Vglobal//d<left><left>", {
				desc = "Set command for deleting line where pattern not matches to command-line",
			})

			vim.keymap.set("n", "<space>cn", ":%Normal ", {
				desc = "Set command for executing normal command to command-line",
			})

			vim.keymap.set("v", "<space>cn", ":Normal ", {
				desc = "Set command for executing normal command to command-line",
			})
		end,
	},
}
