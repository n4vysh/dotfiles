return {
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<space>nd",
				function()
					require("notify").dismiss()
				end,
				desc = "Dismiss notifications",
			},
		},
		opts = {
			render = "wrapped-default",
			max_width = "40",
			on_open = function(win)
				local config = vim.api.nvim_win_get_config(win)
				config.border = "single"
				vim.api.nvim_win_set_config(win, config)
			end,
		},
		config = function(_, opts)
			local notify = require("notify")

			notify.setup(opts)

			vim.notify = notify

			-- selene: allow(incorrect_standard_library_use)
			print = function(...)
				local print_safe_args = {}
				local _ = { ... }
				for i = 1, #_ do
					table.insert(print_safe_args, tostring(_[i]))
				end
				notify(table.concat(print_safe_args, " "), "info")
			end
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"ntpeters/vim-better-whitespace",
		cmd = { "EnableWhitespace", "DisableWhitespace" },
		init = function()
			vim.g.better_whitespace_filetypes_blacklist = {
				"dbout",
				"diff",
				"git",
				"gitcommit",
				"qf",
				"help",
				"markdown",
				"dashboard",
				"Avante",
			}

			do
				local augroup = "vim_better_whitespace"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("InsertEnter", {
					group = augroup,
					pattern = "*",
					callback = function()
						vim.cmd.DisableWhitespace()
					end,
				})
				vim.api.nvim_create_autocmd(
					{ "BufAdd", "BufNewFile", "InsertLeave" },
					{
						group = augroup,
						pattern = "*",
						callback = function()
							if
								vim.bo.filetype ~= "dbout"
								and vim.bo.filetype ~= "diff"
								and vim.bo.filetype ~= "git"
								and vim.bo.filetype ~= "gitcommit"
								and vim.bo.filetype ~= "qf"
								and vim.bo.filetype ~= "help"
								and vim.bo.filetype ~= "markdown"
								and vim.bo.filetype ~= "dashboard"
								and vim.bo.filetype ~= "Avante"
							then
								vim.cmd.EnableWhitespace()
							end
						end,
					}
				)
			end

			-- NOTE: highlight unicode space always
			do
				local augroup = "highlight_extra_whitespace"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("VimEnter", {
					group = augroup,
					callback = function()
						vim.fn.matchadd(
							"ExtraWhitespace",
							"[\\u00A0\\u2000-\\u200B\\u3000]"
						)
					end,
					once = true,
				})
			end
		end,
	},
	{
		"mbbill/undotree",
		keys = {
			{
				"g<C-u>",
				vim.cmd.UndotreeToggle,
				desc = "Toggle undo tree",
			},
		},
		init = function()
			vim.g.undotree_DiffAutoOpen = 0
			vim.g.undotree_SetFocusWhenToggle = 1

			vim.g.undotree_TreeNodeShape = "●"
			vim.g.undotree_TreeVertShape = "│"
			vim.g.undotree_TreeSplitShape = "╱"
			vim.g.undotree_TreeReturnShape = "╲"

			vim.g.undotree_ShortIndicators = 1
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{
				"]r",
				function()
					require("illuminate")["goto_next_reference"]()
				end,
				desc = "Next reference",
			},
			{
				"[r",
				function()
					require("illuminate")["goto_prev_reference"]()
				end,
				desc = "Previous reference",
			},
		},
		opts = {
			filetypes_denylist = {
				"lspinfo",
				"checkhealth",
				"help",
				"man",
				"gitcommit",
				"TelescopePrompt",
				"TelescopeResults",
				"dashboard",
				"lazy",
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},
	{
		"wsdjeg/vim-fetch",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{ "gf", "<cmd>call fetch#cfile(v:count1)<CR>" },
			{ "gf", "<cmd>call fetch#visual(v:count1)<CR>", mode = "x" },
		},
	},
	{
		"moll/vim-bbye",
		keys = {
			{
				"gq",
				"<cmd>Bdelete<cr>",
				silent = true,
				desc = "Delete current buffer",
			},

			{
				"gQ",
				"<cmd>bufdo Bdelete<cr>",
				silent = true,
				desc = "Delete all buffer",
			},

			{
				"g<C-q>",
				"<cmd>Bdelete!<cr>",
				silent = true,
				desc = "Delete current buffer without save",
			},
		},
	},
	{
		-- NOTE: Use for multi line visual star motions
		--       Native feature support only single line in visual mode
		"haya14busa/vim-asterisk",
		keys = {
			{ "*", "<Plug>(asterisk-z*)", mode = { "n", "v" } },
			{ "#", "<Plug>(asterisk-z#)", mode = { "n", "v" } },
			{ "g*", "<Plug>(asterisk-gz*)", mode = { "n", "v" } },
			{ "g#", "<Plug>(asterisk-gz#)", mode = { "n", "v" } },
		},
	},
	{
		"ethanholz/nvim-lastplace",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {
			lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			lastplace_ignore_filetype = {
				"gitcommit",
				"gitrebase",
				"svn",
				"hgcommit",
			},
			lastplace_open_folds = true,
		},
	},
	{
		"luukvbaal/statuscol.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = function()
			local builtin = require("statuscol.builtin")
			return {
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
				},
			}
		end,
	},
	{
		"nvimtools/hydra.nvim",
		event = { "VeryLazy" },
		config = function()
			local hydra = require("hydra")
			local splits = require("smart-splits")

			hydra({
				name = "Window resize",
				mode = "n",
				body = "gw",
				hint = " Window resize: _h_, _l_: ←/→ _j_, _k_: ↓/↑, _<Esc>_: exit ",
				config = {
					invoke_on_body = true,
				},
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
				body = "gz",
				hint = " Side scroll: _h_, _l_: ←/→, _H_, _L_: half screen ←/→, _<Esc>_: exit ",
				config = {
					invoke_on_body = true,
				},
				heads = {
					{ "h", "5zh" },
					{ "l", "5zl", { desc = "←/→" } },
					{ "H", "zH" },
					{ "L", "zL", { desc = "half screen ←/→" } },
				},
			})
		end,
		dependencies = {
			"mrjones2014/smart-splits.nvim",
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
	},
	{
		"kwkarlwang/bufresize.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {},
	},
	{
		"echuraev/translate-shell.vim",
		keys = {
			{
				"<C-t>",
				":Trans<CR>",
				silent = true,
				desc = "Translate word under cursor",
			},

			{
				"<C-t>",
				":Trans -b<CR>",
				silent = true,
				mode = "v",
				desc = "Translate text in visual selection",
			},
		},
		init = function()
			vim.g.trans_join_lines = 1
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {
			enable_tailwind = true,
		},
	},
	{
		"nvchad/minty",
		keys = {
			{
				"gC",
				function()
					require("minty.huefy").open({ border = true })
				end,
				desc = "Open color picker",
			},
		},
		dependencies = {
			{ "nvchad/volt", lazy = true },
		},
	},
	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		opts = {
			modes = { "/", "?" },
		},
		config = function(_, opts)
			local wilder = require("wilder")

			wilder.setup(opts)

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
						accent = wilder.make_hl("WilderAccent", "Pmenu", {
							{ a = 1 },
							{ a = 1 },
							{ foreground = "#7aa2f7", bold = true },
						}),
						selected_accent = wilder.make_hl(
							"WilderAccent",
							"Pmenu",
							{
								{ a = 1 },
								{ a = 1 },
								{ foreground = "#7aa2f7", bold = true },
							}
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

			vim.cmd(
				[[cmap <expr> <C-y> wilder#can_accept_completion() ? wilder#accept_completion() : "\<C-y>"]]
			)

			vim.cmd(
				[[cmap <expr> <C-i> wilder#in_context() ? wilder#next() : "\<Tab>"]]
			)
			vim.cmd(
				[[cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<Tab>"]]
			)
			vim.cmd(
				[[cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<S-Tab>"]]
			)
		end,
		dependencies = {
			{ "romgrk/fzy-lua-native" },
		},
	},
	{
		"sphamba/smear-cursor.nvim",
		event = { "VeryLazy" },
		opts = {
			stiffness = 0.8,
			trailing_stiffness = 0.6,
			trailing_exponent = 0,
			distance_stop_animating = 0.5,
			hide_target_hack = false,
			legacy_computing_symbols_support = true,
		},
	},
	{ "karb94/neoscroll.nvim", opts = {} },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		init = function()
			-- NOTE: remove word and line count on the bottom
			-- https://github.com/nvimdev/dashboard-nvim/issues/131#issuecomment-2558716560
			vim.opt.ruler = false
		end,
		---@type snacks.Config
		opts = {
			indent = {
				filter = function(buf)
					return vim.g.snacks_indent ~= false
						and vim.b[buf].snacks_indent ~= false
						and vim.bo[buf].buftype == ""
						and vim.bo[buf].filetype ~= "dbout"
				end,
			},
			dashboard = {
				preset = {
					keys = {
						{
							icon = " ",
							key = "e",
							desc = "New file",
							action = ":ene",
						},
						{
							icon = " ",
							key = "f",
							desc = "Find files",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = "󰈬 ",
							key = "s",
							desc = "Search word",
							action = ":lua require('user.utils.finder').search()",
						},
						{
							icon = " ",
							key = "h",
							desc = "History",
							action = ":lua require('user.utils.finder').recent_files()",
						},
						{
							icon = " ",
							key = "l",
							desc = "Open last session",
							section = "session",
						},
						{
							icon = " ",
							key = "c",
							desc = "Configuration",
							action = ":lua require('user.utils.finder').edit_config()",
						},
						{
							icon = " ",
							key = "q",
							desc = "Quit",
							action = ":qa",
						},
					},
				},
				sections = {
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
			styles = {
				dashboard = {
					bo = {
						filetype = "dashboard",
					},
				},
			},
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"folke/persistence.nvim",
				event = "BufReadPre",
				opts = {},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		init = function()
			-- HACK: use non-breaking space to remove statusline before load lualine
			--       https://github.com/neovim/neovim/issues/5626
			vim.opt.statusline = " "
		end,
		opts = function()
			-- NOTE: count selected line only
			--       builtin selectioncount component gives the wrong size
			-- https://github.com/nvim-lualine/lualine.nvim/issues/1012
			-- https://github.com/nvim-lualine/lualine.nvim/blob/86fe39534b7da729a1ac56c0466e76f2c663dc42/lua/lualine/components/selectioncount.lua
			local function linecount()
				local mode = vim.fn.mode(true)
				local line_start = vim.fn.line("v")
				local line_end = vim.fn.line(".")
				if
					mode:match("")
					or mode:match("V")
					or line_start ~= line_end
				then
					return math.abs(line_start - line_end) + 1
				else
					return ""
				end
			end

			return {
				options = {
					theme = "tokyonight",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					icons_enabled = true,
					globalstatus = true,
					disabled_filetypes = {
						statusline = { "dashboard" },
					},
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
					lualine_x = {
						"encoding",
						"bo:fileformat",
						"bo:filetype",
					},
					lualine_y = {},
					lualine_z = {
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
						},
						"searchcount",
						linecount,
						"progress",
						"location",
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = {
					"man",
					"nvim-tree",
					"quickfix",
					"toggleterm",
				},
			}
		end,
		dependencies = {
			{
				"folke/tokyonight.nvim",
				-- NOTE: load colorscheme before all the other start plugins
				lazy = false,
				priority = 1000,
				opts = {
					style = "night",
					transparent = true,
					hide_inactive_statusline = true,
					sidebars = { "qf", "help", "terminal", "packer" },
					on_highlights = function(hl, c)
						hl.ExtraWhitespace = {
							bg = c.error,
						}
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
						hl.FoldColumn = {
							fg = "#737aa2",
							bold = true,
						}
						hl.Comment = {
							fg = "#737aa2",
							bold = true,
						}
						hl.DiagnosticUnnecessary = {
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
						hl.NeotestIndent = {
							fg = c.comment,
						}
						hl.NeotestExpandMarker = {
							fg = c.comment,
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
							bg = "#1d3450",
						}
						hl.DiffDelete = {
							bg = "#5f0000",
						}
						hl.DiffChange = {
							bg = "#008700",
						}
						hl.DiffText = {
							bg = "#1d3b40",
						}
					end,
				},
				config = function(_, opts)
					require("tokyonight").setup(opts)

					vim.cmd.colorscheme("tokyonight")
				end,
			},
		},
	},
	{
		"akinsho/nvim-bufferline.lua",
		event = { "BufReadPre", "BufAdd", "BufNewFile" },
		keys = {
			{
				"]b",
				function()
					require("bufferline").cycle(1)
				end,
				silent = true,
				desc = "Go to next buffer",
			},
			{
				"[b",
				function()
					require("bufferline").cycle(-1)
				end,
				silent = true,
				desc = "Go to previous buffer",
			},
			{
				">b",
				function()
					require("bufferline").move(1)
				end,
				silent = true,
				desc = "Move the current buffer forwards",
			},
			{
				"<b",
				function()
					require("bufferline").move(-1)
				end,
				silent = true,
				desc = "Move the current buffer backwards",
			},
			{
				"<space>bo",
				"<cmd>BufferLineCloseOthers<cr>",
				silent = true,
				desc = "Make the current buffer the only one on the screen",
			},
		},
		opts = {
			highlights = {
				fill = {
					bg = "black",
				},
			},
			options = {
				buffer_close_icon = "",
				close_icon = "",
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
						filetype = "sagaoutline",
						text = "Outline",
						text_align = "center",
					},
					{
						filetype = "DiffviewFiles",
						text = "Diff",
						text_align = "center",
					},
					{
						filetype = "neotest-summary",
						text = "Test",
						text_align = "center",
					},
				},
			},
		},
		dependencies = {
			{ "tiagovla/scope.nvim", config = true },
		},
	},
	{
		"jpalardy/vim-slime",
		keys = {
			{
				"<c-c><c-c>",
				"<plug>SlimeRegionSend",
				desc = "Send commands",
				mode = { "x" },
			},
		},
		init = function()
			vim.g.slime_no_mappings = 1
			vim.g.slime_target = "tmux"
			vim.g.slime_dont_ask_default = 1
			vim.g.slime_default_config = {
				socket_name = "default",
				target_pane = "{last}",
			}
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<space>nn",
				"<cmd>Noice pick<cr>",
				silent = true,
				desc = "View notification history",
			},
		},
		init = function()
			vim.opt.cmdheight = 0
		end,
		opts = {
			messages = {
				view_search = false,
			},
			lsp = {
				progress = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
			views = {
				cmdline_popup = {
					border = {
						style = "single",
					},
				},
			},
			routes = {
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = "--No lines in buffer--",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = " lines yanked",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = " fewer lines",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = " more lines",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = " lines >ed",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = " lines <ed",
					},
				},
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = "Hunk .* of .*",
					},
				},
				-- for vim-asterisk
				{
					opts = { skip = true },
					filter = {
						event = "msg_show",
						find = "\\<.*\\>",
					},
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"hrsh7th/nvim-cmp",
			"smjonas/inc-rename.nvim",
		},
	},
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/menu",
		lazy = true,
		keys = {
			{
				"<RightMouse>",
				function()
					require("menu.utils").delete_old_menus()

					vim.cmd.exec('"normal! \\<RightMouse>"')

					local buf =
						vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
					local options = vim.bo[buf].ft == "NvimTree" and "nvimtree"
						or "default"

					require("menu").open(options, { mouse = true })
				end,
				mode = { "n", "v" },
			},
		},
	},
}
