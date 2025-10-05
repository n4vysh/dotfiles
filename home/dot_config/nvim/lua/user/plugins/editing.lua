return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "x" } },
			{ "gb", mode = { "n", "x" } },
			{ "gcc" },
			{ "gcb" },
			{ "gco" },
			{ "gcO" },
			{ "gcA" },
		},
		opts = function()
			return {
				pre_hook = require(
					"ts_context_commentstring.integrations.comment_nvim"
				).create_pre_hook(),
			}
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{
		"tpope/vim-abolish",
		-- NOTE: use only coercion
		keys = {
			"crc",
			"crp",
			"crm",
			"cr_",
			"crs",
			"cru",
			"crU",
			"crk",
			"cr-",
			"cr.",
		},
		config = function()
			vim.opt.iskeyword:append({ "-" })
		end,
	},
	{
		"MagicDuck/grug-far.nvim",
		keys = {
			{
				"<space>rr",
				function()
					require("grug-far").open()
				end,
				desc = "Search and replace",
			},
			{
				"<space>rr",
				function()
					require("grug-far").with_visual_selection()
				end,
				desc = "Search and replace current word",
				mode = "v",
			},
		},
		opts = {
			resultsSeparatorLineChar = "━",
			keymaps = {
				close = { n = "q" },
				help = { n = "<C-_>" },
			},
		},
	},
	{
		"cshuaimin/ssr.nvim",
		keys = {
			{
				"<space>rs",
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
			{
				"ga",
				"<Plug>(EasyAlign)",
				mode = { "x", "n" },
				desc = "Align text",
			},
		},
	},
	{
		"mg979/vim-visual-multi",
		keys = { { "<C-n>", mode = { "n", "x" } }, { "<M-j>" }, { "<M-k>" } },
		init = function()
			vim.g.VM_theme = "neon"
			vim.g.VM_silent_exit = 1
			vim.g.VM_set_statusline = 0
			vim.g.VM_maps = {
				["Add Cursor Down"] = "<M-j>",
				["Add Cursor Up"] = "<M-k>",
				-- NOTE: disable backspace and <C-w> mapping for autopairs
				-- https://github.com/mg979/vim-visual-multi/issues/172#issuecomment-1092293500
				["I BS"] = "",
				["I CtrlW"] = "",
			}

			vim.g.VM_custom_motions = {
				-- helix-like keymaps
				["gh"] = "0",
				["gl"] = "$",
				["gs"] = "^",
			}

			-- NOTE: Use clipboard
			-- https://github.com/mg979/vim-visual-multi/issues/116#issuecomment-639322793
			vim.cmd(
				[[autocmd User visual_multi_mappings nmap <buffer> p "+<Plug>(VM-p-Paste)]]
			)
		end,
	},
	{
		"kana/vim-textobj-entire",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-datetime",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"LeonB/vim-textobj-url",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-textobj-indent",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "kana/vim-textobj-user",
	},
	{
		"kana/vim-operator-replace",
		keys = {
			{
				"cx",
				"<Plug>(operator-replace)",
				silent = true,
				desc = "Replace text",
				remap = true,
			},
			{
				"gX",
				"<Plug>(operator-replace)",
				mode = "x",
				silent = true,
				desc = "Replace text",
				remap = true,
			},
		},
		dependencies = "kana/vim-operator-user",
	},
	{
		-- NOTE: nvim-treesitter-textobjects not work multiline comments
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133
		"glts/vim-textobj-comment",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
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
			vim.keymap.set(
				{ "o", "x" },
				"af",
				"<plug>(textobj-markdown-chunk-a)",
				{
					silent = true,
					desc = "around the current fence",
				}
			)
			vim.keymap.set(
				{ "o", "x" },
				"if",
				"<plug>(textobj-markdown-chunk-i)",
				{
					silent = true,
					desc = "inside the current fence",
				}
			)
			vim.keymap.set(
				{ "o", "x" },
				"aF",
				"<plug>(textobj-markdown-Bchunk-a)",
				{
					silent = true,
					desc = "around the backward fence",
				}
			)
			vim.keymap.set(
				{ "o", "x" },
				"iF",
				"<plug>(textobj-markdown-Bchunk-i)",
				{
					silent = true,
					desc = "inside the backward fence",
				}
			)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			map_c_h = true,
			map_c_w = true,
		},
	},
	{
		"danymat/neogen",
		keys = {
			{
				"gcg",
				function()
					require("neogen").generate({})
				end,
				silent = true,
				desc = "Generate comment",
			},
		},
		opts = {
			snippet_engine = "luasnip",
		},
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"tpope/vim-repeat",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
	},

	{
		"kylechui/nvim-surround",
		keys = {
			{ "<C-g>z", mode = "i" },
			{ "<C-g>Z", mode = "i" },
			{ "yz" },
			{ "yzz" },
			{ "yZ" },
			{ "yZZ" },
			{ "gz", mode = "x" },
			{ "gZ", mode = "x" },
			{ "dz" },
			{ "cz" },
			{ "cZ" },
		},
		-- HACK: change keymap to avoid conflict for leap.nvim and helix-like keymaps
		-- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
		opts = {
			keymaps = {
				insert = "<C-g>z",
				insert_line = "<C-g>Z",
				normal = "yz",
				normal_line = "yzz",
				normal_cur = "yZ",
				normal_cur_line = "yZZ",
				visual = "gz",
				visual_line = "gZ",
				delete = "dz",
				change = "cz",
			},
		},
	},
	{
		"wellle/targets.vim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
	},
	{
		"Wansmer/treesj",
		keys = {
			{ "gS", "<cmd>TSJSplit<cr>", desc = "Split node under cursor" },
			{ "gJ", "<cmd>TSJJoin<cr>", desc = "Join node under cursor" },
		},
		opts = { use_default_keymaps = false },
		dependencies = { "nvim-treesitter" },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			-- NOTE: normal and visual mode
			{
				"<space>riv",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				mode = { "n", "x" },
				noremap = true,
				silent = true,
				expr = false,
				desc = "Inline variable",
			},
			{
				"<space>rv",
				function()
					require("refactoring").debug.print_var({})
				end,
				mode = { "n", "x" },
				desc = "Add debug print_var",
			},
			-- NOTE: normal mode only
			{
				"<space>ree",
				function()
					require("refactoring").refactor("Extract Block")
				end,
				mode = "n",
				silent = true,
				desc = "Extract block",
			},
			{
				"<space>ref",
				function()
					require("refactoring").refactor("Extract Block To File")
				end,
				mode = "n",
				silent = true,
				desc = "Extract block to file",
			},
			{
				"<space>rii",
				function()
					require("refactoring").refactor("Inline Function")
				end,
				mode = { "n" },
				silent = true,
				desc = "Inline function",
			},
			{
				"<space>rp",
				function()
					require("refactoring").debug.printf({ below = false })
				end,
				mode = { "n" },
				desc = "Add debug printf",
			},
			{
				"<space>rc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				mode = { "n" },
				desc = "Cleanup debug print",
			},
			-- NOTE: visual mode only
			{
				"<space>ree",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				mode = "x",
				silent = true,
				desc = "Extract function",
			},
			{
				"<space>ref",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				mode = "x",
				silent = true,
				desc = "Extract function to file",
			},
			{
				"<space>rev",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				mode = "x",
				silent = true,
				desc = "Extract variable",
			},
		},
		opts = {},
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "visual")
				end,
				mode = "v",
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "visual")
				end,
				mode = "v",
				desc = "Decrement",
			},
			{
				"g<C-a>",
				function()
					require("dial.map").manipulate("increment", "gvisual")
				end,
				mode = "v",
				desc = "Increment",
			},
			{
				"g<C-x>",
				function()
					require("dial.map").manipulate("decrement", "gvisual")
				end,
				mode = "v",
				desc = "Decrement",
			},
		},
		opts = function()
			local augend = require("dial.augend")

			return {
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
						elements = { "enable", "disable" },
						cyclic = true,
					}),
					augend.constant.new({
						-- NOTE: uppercase of augend.constant.alias.bool
						elements = { "TRUE", "FALSE" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "asc", "desc" },
						preserve_case = true,
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
						-- NOTE: uppercase of augend.constant.alias.bool
						elements = { "TRUE", "FALSE" },
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "asc", "desc" },
						preserve_case = true,
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
			}
		end,
		config = function(_, opts)
			require("dial.config").augends:register_group(opts)
		end,
	},
	{
		"smjonas/live-command.nvim",
		keys = {
			{ "<space>c<C-s>", ":%Sort ", desc = "Set command for sort" },
			{
				"<space>c<C-s>",
				mode = "v",
				":Sort ",
				desc = "Set command for sort",
			},
			{
				"<space>cd",
				":%Global//d<left><left>",
				desc = "Set command to delete with global",
			},
			{
				"<space>cd",
				mode = "v",
				":Global//d<left><left>",
				desc = "Set command to delete with global",
			},
			{
				"<space>c<C-d>",
				":%Vglobal//d<left><left>",
				desc = "Set command to delete with vglobal",
			},
			{
				"<space>c<C-d>",
				mode = "v",
				":Vglobal//d<left><left>",
				desc = "Set command to delete with vglobal",
			},
		},
		main = "live-command",
		opts = {
			commands = {
				Global = { cmd = "global" },
				Vglobal = { cmd = "vglobal" },
				Sort = { cmd = "sort" },
			},
		},
	},
}
