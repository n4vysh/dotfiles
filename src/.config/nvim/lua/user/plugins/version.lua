return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 0,
				},
				current_line_blame_formatter = "   <author> • <author_time:%Y-%m-%d> • <summary>",
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "<space>vr", gs.reset_hunk, { desc = "Reset hunk" })
					map("n", "<space>vp", gs.preview_hunk, { desc = "Preview hunk" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", {
						silent = true,
						desc = "Select hunk",
					})
				end,
			})
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
	},

	{
		"ruifm/gitlinker.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<space>vo",
				function()
					require("gitlinker").get_buf_range_url(
						"n",
						{ action_callback = require("gitlinker.actions").open_in_browser }
					)
				end,
				silent = true,
				desc = "Open link in browser",
			},
			{
				"<space>vo",
				function()
					require("gitlinker").get_buf_range_url(
						"v",
						{ action_callback = require("gitlinker.actions").open_in_browser }
					)
				end,
				mode = "v",
				silent = true,
				desc = "Open link in browser",
			},
			{
				"<space>vy",
				function()
					require("gitlinker").get_buf_range_url("n")
				end,
				silent = true,
				desc = "Yank link",
			},
			{
				"<space>vy",
				function()
					require("gitlinker").get_buf_range_url("v")
				end,
				mode = "v",
				silent = true,
				desc = "Yank link",
			},
		},
		config = function()
			local gitlinker = require("gitlinker")
			gitlinker.setup({
				ops = {
					print_url = false,
				},
				mappings = nil,
			})
		end,
	},

	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<Space>vd", ":DiffviewOpen<cr><c-w>l", silent = true, desc = "Open diff view" },
			{
				"<Space>vh",
				":DiffviewFileHistory %<cr>",
				mode = { "n", "v" },
				silent = true,
				desc = "Open file history",
			},
		},
		config = function()
			local diffview = require("diffview")
			diffview.setup({
				enhanced_diff_hl = true,
				key_bindings = {
					file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
					file_panel = { q = "<Cmd>DiffviewClose<CR>" },
					view = { q = "<Cmd>DiffviewClose<CR>" },
				},
			})
		end,
	},
}
