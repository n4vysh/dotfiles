return {
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{
				"<space>sp",
				function()
					require("telescope.builtin").builtin()
				end,
				silent = true,
				desc = "Search for pickers",
			},
			{
				"<space>bb",
				function()
					require("telescope.builtin").buffers()
				end,
				silent = true,
				desc = "Switch buffer",
			},
			{
				"<c-p>",
				function()
					require("telescope.builtin").find_files()
				end,
				silent = true,
				desc = "Search for files",
			},
			{
				"<space>fh",
				function()
					require("user.utils.finder").recent_files()
				end,
				silent = true,
				desc = "Search for recent files",
			},
			{
				"<space>fc",
				function()
					require("user.utils.finder").edit_config()
				end,
				silent = true,
				desc = "Search for config files",
			},
			{
				"<space>fd",
				function()
					local builtin = require("telescope.builtin")
					builtin.git_files({
						cwd = os.getenv("XDG_DATA_HOME") .. "/dotfiles/src/",
					})
				end,
				silent = true,
				desc = "Search for dotfiles",
			},
			{
				"<space>fm",
				function()
					local telescope = require("telescope")
					telescope.load_extension("file_browser")
					telescope.extensions.file_browser.file_browser()
				end,
				silent = true,
				desc = "Toggle file manager",
			},
			{
				"<space>s/",
				function()
					require("user.utils.finder").search()
				end,
				silent = true,
				desc = "Search for a string",
			},
			{
				"<space>ss",
				function()
					local telescope = require("telescope")
					telescope.load_extension("luasnip")
					telescope.extensions.luasnip.luasnip()
				end,
				silent = true,
				desc = "Search for snippets",
			},
			{
				"<space>sa",
				function()
					require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({
						postfix = "",
						quote = false,
					})
				end,
				silent = true,
				desc = "Search for the string under cursor",
			},
			{
				"<space>sa",
				function()
					-- NOTE: grep_visual_selection shortcut not work
					-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim/issues/55
					function vim.getVisualSelection()
						vim.cmd('noau normal! "vy"')
						local text = vim.fn.getreg("v")
						vim.fn.setreg("v", {})

						text = string.gsub(text, "\n", "")
						if #text > 0 then
							return text
						else
							return ""
						end
					end

					local text = vim.getVisualSelection()

					require("user.utils.finder").search({ default_text = text })
				end,
				silent = true,
				desc = "Search for the string under cursor",
				mode = "v",
			},
			{
				"<space>sk",
				function()
					require("telescope.builtin").keymaps({})
				end,
				silent = true,
				desc = "Search for keymaps",
			},

			{
				"<space>sh",
				function()
					require("telescope.builtin").help_tags()
				end,
				silent = true,
				desc = "Search for help info",
			},

			{
				"<space>vf",
				function()
					require("telescope.builtin").git_files()
				end,
				silent = true,
				desc = "Search for tracked files",
			},

			{
				"<space>sm",
				function()
					require("telescope.builtin").man_pages()
				end,
				silent = true,
				desc = "Search for manual pages",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			local telescope_config = require("telescope.config")

			local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			-- NOTE: Use custom action to select multiple files
			-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1679797700
			local select_one_or_multi = function(prompt_bufnr)
				local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
				local multi = picker:get_multi_selection()
				if not vim.tbl_isempty(multi) then
					require("telescope.actions").close(prompt_bufnr)
					for _, j in pairs(multi) do
						if j.path ~= nil then
							vim.cmd(string.format("%s %s", "edit", j.path))
						end
					end
				else
					require("telescope.actions").select_default(prompt_bufnr)
				end
			end

			telescope.setup({
				defaults = require("telescope.themes").get_dropdown({
					vimgrep_arguments = vimgrep_arguments,
					mappings = {
						i = {
							["<C-f>"] = false,
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<CR>"] = select_one_or_multi,
							["<C-s>"] = actions.select_horizontal,
						},
						n = {
							["<Esc>"] = false,
						},
					},
					prompt_prefix = "▶ ",
					borderchars = {
						{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
						prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
						results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
						preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					},
				}),
				pickers = {
					find_files = {
						hidden = true,
						no_ignore = true,
						find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!**/.git/*" },
					},
					buffers = {
						show_all_buffers = true,
						ignore_current_buffer = true,
						mappings = {
							n = {
								["dd"] = actions.delete_buffer,
							},
						},
					},
					git_files = {
						hidden = true,
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true,
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
							},
						},
					},
					file_browser = {
						initial_mode = "normal",
						hide_parent_dir = true,
						respect_gitignore = false,
						grouped = true,
						mappings = {
							n = {
								["h"] = fb_actions.goto_parent_dir,
								["l"] = actions.select_default,
								["."] = fb_actions.toggle_hidden,
							},
						},
					},
				},
			})
			telescope.load_extension("fzf")
		end,
		dependencies = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
			{
				"nvim-telescope/telescope-file-browser.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{ "smartpde/telescope-recent-files" },
			{ "benfowler/telescope-luasnip.nvim" },
		},
	},
}
