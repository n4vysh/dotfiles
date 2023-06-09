return {
	{ "RRethy/vim-illuminate" },
	{ "kyazdani42/nvim-web-devicons" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "romainl/vim-cool" },
	{
		"moll/vim-bbye",
		config = function()
			vim.keymap.set("n", "gq", "<cmd>Bdelete<cr>", {
				silent = true,
				desc = "Delete current buffer",
			})

			vim.keymap.set("n", "gQ", "<cmd>bufdo Bdelete<cr>", {
				silent = true,
				desc = "Delete all buffer",
			})

			vim.keymap.set("n", "g<C-q>", "<cmd>Bdelete!<cr>", {
				silent = true,
				desc = "Delete current buffer without save",
			})
		end,
	},
	{
		-- NOTE: Use for multi line visual star motions
		--       Native feature support only single line in visual mode
		"haya14busa/vim-asterisk",
		config = function()
			vim.cmd([[
				map *  <Plug>(asterisk-z*)
				map #  <Plug>(asterisk-z#)
				map g* <Plug>(asterisk-gz*)
				map g# <Plug>(asterisk-gz#)
			]])
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"anuvyklack/hydra.nvim",
		dependencies = {
			"mrjones2014/smart-splits.nvim",
		},
		config = function()
			local hydra = require("hydra")
			local splits = require("smart-splits")

			hydra({
				name = "Window resize",
				mode = "n",
				body = "<space>w",
				heads = {
					{
						"h",
						function()
							splits.resize_left(2)
						end,
					},
					{
						"l",
						function()
							splits.resize_right(2)
						end,
						{ desc = "←/→" },
					},
					{
						"j",
						function()
							splits.resize_down(2)
						end,
					},
					{
						"k",
						function()
							splits.resize_up(2)
						end,
						{ desc = "↓/↑" },
					},
				},
			})

			hydra({
				name = "Side scroll",
				mode = "n",
				body = "<space>z",
				heads = {
					{ "h", "5zh" },
					{ "l", "5zl", { desc = "←/→" } },
					{ "H", "zH" },
					{ "L", "zL", { desc = "half screen ←/→" } },
				},
			})
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
			{
				"Shatur/neovim-session-manager",
				config = function()
					require("session_manager").setup({
						autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
					})
				end,
			},
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {}
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", ":ene<CR>"),
				dashboard.button("f", "󰈞  Find files", ":lua require('user.utils.finder').find_files()<cr>"),
				dashboard.button("s", "󰈬  Search word", ":lua require('user.utils.finder').search()<cr>"),
				dashboard.button("t", "󰙅  Open file tree", ":NvimTreeToggle<CR>"),
				dashboard.button("m", "  Jump to bookmarks", ":lua require('harpoon.ui').toggle_quick_menu()<cr>"),
				dashboard.button("h", "  History", ":lua require('user.utils.finder').recent_files()<cr>"),
				dashboard.button("l", "  Open last session", ":SessionManager load_last_session<cr>"),
				dashboard.button("c", "  Configuration", ":lua require('user.utils.finder').edit_config()<cr>"),
				dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
			}
			alpha.setup(dashboard.config)
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		init = function()
			vim.g.undotree_SplitWidth = 35
			vim.g.undotree_SetFocusWhenToggle = 1

			vim.keymap.set("n", "g<C-u>", ":UndotreeToggle<cr>", {
				silent = true,
				desc = "Toggle the undo-tree panel",
			})
		end,
	},
	{
		"kwkarlwang/bufresize.nvim",
		config = function()
			require("bufresize").setup()
		end,
	},
	{
		"echuraev/translate-shell.vim",
		init = function()
			vim.g.trans_join_lines = 1
		end,
		config = function()
			vim.keymap.set("n", "<C-t>", ":Trans<CR>", {
				silent = true,
				desc = "Translate word under cursor",
			})

			vim.keymap.set("v", "<C-t>", ":Trans -b<CR>", {
				silent = true,
				desc = "Translate text in visual selection",
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		init = function()
			vim.opt.termguicolors = true
		end,
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		config = function()
			require("ccc").setup()

			vim.keymap.set("n", "gC", function()
				require("ccc.ui"):open(false)
			end, {
				desc = "Open color picker",
			})
		end,
	},
	{
		"gelguy/wilder.nvim",
		config = function()
			local wilder = require("wilder")
			wilder.setup({
				modes = { ":", "/", "?" },
			})
			wilder.set_option("use_python_remote_plugin", 0)
			wilder.set_option("enable_cmdline_enter", 0)

			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.cmdline_pipeline({
						fuzzy = 1,
						fuzzy_filter = wilder.lua_fzy_filter(),
					}),
					wilder.vim_search_pipeline({})
				),
			})

			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
					highlighter = wilder.lua_fzy_highlighter(),
					highlights = {
						accent = wilder.make_hl(
							"WilderAccent",
							"Pmenu",
							{ { a = 1 }, { a = 1 }, { foreground = "#7aa2f7", bold = true } }
						),
						selected_accent = wilder.make_hl(
							"WilderAccent",
							"Pmenu",
							{ { a = 1 }, { a = 1 }, { foreground = "#7aa2f7", bold = true } }
						),
					},
					left = {
						wilder.popupmenu_devicons(),
					},
					right = {
						" ",
						wilder.popupmenu_scrollbar(),
					},
					winblend = 15,
					max_height = "30%",
				}))
			)

			vim.cmd([[cmap <expr> <C-y> wilder#can_accept_completion() ? wilder#accept_completion() : "\<C-y>"]])

			vim.cmd([[cmap <expr> <C-i> wilder#in_context() ? wilder#next() : "\<Tab>"]])
			vim.cmd([[cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<Tab>"]])
			vim.cmd([[cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<S-Tab>"]])
		end,
		dependencies = {
			{ "romgrk/fzy-lua-native" },
		},
	},

	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},

	{
		"SmiteshP/nvim-navic",
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				highlight = true,
			})
			vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
		end,
		dependencies = "neovim/nvim-lspconfig",
	},
	{
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					icons_enabled = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							format = function(mode_name)
								return mode_name:sub(1, 1)
							end,
						},
					},
					lualine_b = {},
					lualine_c = {
						{ "branch", icon = "" },
						{ "diagnostics", sources = { "nvim_diagnostic" } },
					},
					lualine_x = { "encoding", "bo:fileformat", "bo:filetype" },
					lualine_y = {},
					lualine_z = { "progress", "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "man", "nvim-tree", "quickfix", "symbols-outline", "toggleterm" },
			})
		end,
		dependencies = {
			{
				"folke/tokyonight.nvim",
				config = function()
					require("tokyonight").setup({
						style = "night",
						transparent = true,
						hide_inactive_statusline = true,
						sidebars = { "qf", "help", "terminal", "packer" },
						on_highlights = function(hl, c)
							hl.TelescopeBorder = {
								fg = c.blue0,
							}
							hl.TelescopePromptBorder = {
								fg = c.blue0,
							}
							hl.TelescopePromptTitle = {
								fg = c.blue0,
							}
							hl.TelescopePreviewTitle = {
								fg = c.blue0,
							}
							hl.TelescopeResultsTitle = {
								fg = c.blue0,
							}
							hl.Comment = {
								fg = "#737aa2",
								bold = true,
							}
							hl.GitSignsCurrentLineBlame = {
								fg = "#737aa2",
								bold = true,
							}
							hl.LineNr = {
								fg = "#606687",
							}
							hl.CursorLineNr = {
								fg = "#737aa2",
								bold = true,
							}
							hl.WinSeparator = {
								bg = "NONE",
								fg = "#569CD6",
							}
							hl.CmpItemKindText = {
								bg = "NONE",
								fg = "#9CDCFE",
							}
							hl.DiffAdd = {
								bg = "#005f00",
							}
							hl.DiffDelete = {
								bg = "#5f0000",
							}
							hl.DiffChange = {
								bg = "#008700",
							}
						end,
					})

					vim.opt.termguicolors = true
					vim.cmd.colorscheme("tokyonight")
				end,
			},
		},
	},

	{
		"akinsho/nvim-bufferline.lua",
		config = function()
			require("bufferline").setup({
				options = {
					show_buffer_close_icons = false,
					show_close_icon = false,
					separator_style = { "", "" },
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Tree",
							text_align = "center",
						},
						{
							filetype = "undotree",
							text = "Undo Tree",
							text_align = "center",
						},
						{
							filetype = "dbui",
							text = "DB",
							text_align = "center",
						},
						{
							filetype = "Outline",
							text = "Outline",
							text_align = "center",
						},
						{
							filetype = "packer",
							text = "Package",
							text_align = "center",
						},
						{
							filetype = "DiffviewFiles",
							text = "Diff",
							text_align = "center",
						},
					},
				},
			})

			vim.keymap.set("n", "]b", function()
				require("bufferline").cycle(1)
			end, {
				silent = true,
				desc = "Go to next buffer",
			})

			vim.keymap.set("n", "[b", function()
				require("bufferline").cycle(-1)
			end, {
				silent = true,
				desc = "Go to previous buffer",
			})

			vim.keymap.set("n", ">b", function()
				require("bufferline").move(1)
			end, {
				silent = true,
				desc = "Move the current buffer forwards",
			})

			vim.keymap.set("n", "<b", function()
				require("bufferline").move(-1)
			end, {
				silent = true,
				desc = "Move the current buffer backwards",
			})

			for i = 1, 9 do
				local num
				if i == 1 then
					num = i .. "st"
				elseif i == 2 then
					num = i .. "nd"
				elseif i == 3 then
					num = i .. "rd"
				else
					num = i .. "th"
				end
				vim.keymap.set("n", "<Space>b" .. i, function()
					require("bufferline").go_to_buffer(i, true)
				end, {
					silent = true,
					desc = string.format("Go to the %s visible buffer", num),
				})
			end
		end,
	},
}
