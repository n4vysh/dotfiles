return {
	{
		"tpope/vim-abolish",
		event = { "VeryLazy" },
		config = function()
			vim.opt.iskeyword:append({ "-" })
		end,
	},
	{
		"tommcdo/vim-exchange",
		keys = {
			-- HACK: change keymap to avoid conflict for leap.nvim
			-- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
			{ "cx", "<Plug>(Exchange)", silent = true },
			{ "gX", "<Plug>(Exchange)", mode = "x", silent = true },
			{ "cxc", "<Plug>(ExchangeClear)", silent = true },
			{ "cxx", "<Plug>(ExchangeLine)", silent = true },
		},
		init = function()
			vim.g.exchange_no_mappings = 1
		end,
	},
	{
		"windwp/nvim-spectre",
		keys = {
			{
				"<space>sr",
				function()
					require("spectre").open()
				end,
				desc = "Search and replace",
			},
			{
				"<space>sr",
				-- https://github.com/nvim-pack/nvim-spectre/issues/79
				":lua require('spectre').open_visual()<CR>",
				desc = "Search and replace current word",
				mode = "v",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"cshuaimin/ssr.nvim",
		keys = {
			{
				"<space>s<C-r>",
				"<cmd>lua require('ssr').open()<cr>",
				mode = { "n", "x" },
				desc = "Structural search and replace",
			},
		},
		opts = {},
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, desc = "Align text" },
		},
	},
	{
		"mg979/vim-visual-multi",
		event = { "VeryLazy" },
		init = function()
			vim.g.VM_theme = "neon"
			vim.g.VM_silent_exit = 1
			vim.g.VM_set_statusline = 0
			-- disable backspace mapping for autopairs
			-- https://github.com/mg979/vim-visual-multi/issues/172#issuecomment-1092293500
			vim.g.VM_maps = {
				["I BS"] = "",
				["Select Cursor Down"] = "<M-j>",
				["Select Cursor Up"] = "<M-k>",
			}

			-- NOTE: Use clipboard
			-- https://github.com/mg979/vim-visual-multi/issues/116#issuecomment-639322793
			vim.cmd([[autocmd User visual_multi_mappings nmap <buffer> p "+<Plug>(VM-p-Paste)]])
		end,
	},
	{
		"kana/vim-textobj-entire",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-line",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-datetime",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"mattn/vim-textobj-url",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"pianohacker/vim-textobj-indented-paragraph",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-indent",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		-- NOTE: nvim-treesitter-textobjects not work multiline comments
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133
		"glts/vim-textobj-comment",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"rsrchboy/vim-textobj-heredocs",
		event = { "VeryLazy" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"coachshea/vim-textobj-markdown",
		ft = { "markdown" },
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
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"danymat/neogen",
		keys = {
			{
				"gca",
				function()
					require("neogen").generate()
				end,
				silent = true,
				desc = "Generate annotation",
			},
		},
		opts = {
			snippet_engine = "luasnip",
		},
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"tpope/vim-repeat",
		event = { "VeryLazy" },
	},
	{
		"kylechui/nvim-surround",
		event = { "VeryLazy" },
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
	{
		"wellle/targets.vim",
		event = { "VeryLazy" },
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		keys = {
			{ "gS", "<cmd>TSJSplit<cr>", desc = "Split node under cursor" },
			{ "gJ", "<cmd>TSJJoin<cr>", desc = "Join node under cursor" },
		},
		opts = { use_default_keymaps = false },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<space>re",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				mode = "v",
				silent = true,
				desc = "Extract function",
			},
			{
				"<space>rf",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				mode = "v",
				silent = true,
				desc = "Extract function to file",
			},
			{
				"<space>rv",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				mode = "v",
				silent = true,
				desc = "Extract variable",
			},
			{
				"<space>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				mode = "v",
				silent = true,
				desc = "Inline variable",
			},
			{
				"<space>rb",
				function()
					require("refactoring").refactor("Extract Block")
				end,
				silent = true,
				desc = "Extract block",
			},
			{
				"<space>rbf",
				function()
					require("refactoring").refactor("Extract Block To File")
				end,
				silent = true,
				desc = "Extract block to file",
			},
			{
				"<space>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				noremap = true,
				silent = true,
				expr = false,
				desc = "Inline variable",
			},
			{
				"<space>rr",
				function()
					require("telescope").load_extension("refactoring")
					require("telescope").extensions.refactoring.refactors()
				end,
				mode = "v",
				desc = "Search for refactor operations",
			},
			{
				"<space>rp",
				function()
					require("refactoring").debug.printf({ below = false })
				end,
				desc = "Add debug printf",
			},
			{
				"<space>rv",
				function()
					require("refactoring").debug.print_var()
				end,
				mode = { "n", "x" },
				desc = "Add debug print_var",
			},
			{
				"<space>rc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				desc = "Cleanup debug print",
			},
		},
		opts = {},
	},
	{
		"monaqa/dial.nvim",
		event = { "VeryLazy" },
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
		event = { "VeryLazy" },
		config = function()
			require("live-command").setup({
				commands = {
					Global = { cmd = "global" },
					Vglobal = { cmd = "vglobal" },
					Sort = { cmd = "sort" },
				},
			})

			vim.keymap.set("n", "<space>c<C-s>", ":%Sort ", {
				desc = "Set command for sort",
			})

			vim.keymap.set("v", "<space>c<C-s>", ":Sort ", {
				desc = "Set command for sort",
			})

			vim.keymap.set("n", "<space>cd", ":%Global//d<left><left>", {
				desc = "Set command to delete with global",
			})

			vim.keymap.set("v", "<space>cd", ":Global//d<left><left>", {
				desc = "Set command to delete with global",
			})

			vim.keymap.set("n", "<space>c<C-d>", ":%Vglobal//d<left><left>", {
				desc = "Set command to delete with vglobal",
			})

			vim.keymap.set("v", "<space>c<C-d>", ":Vglobal//d<left><left>", {
				desc = "Set command to delete with vglobal",
			})
		end,
	},
}
