return {
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			local telescope = require("telescope")
			local lga_actions = require("telescope-live-grep-args.actions")

			local telescope_config = require("telescope.config")

			local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			telescope.setup({
				defaults = require("telescope.themes").get_dropdown({
					vimgrep_arguments = vimgrep_arguments,
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
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
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
				extensions = {
					fzf = {
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					heading = {
						treesitter = true,
					},
					live_grep_args = {
						auto_quoting = true,
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
							},
						},
					},
				},
			})
			telescope.load_extension("fzf")

			vim.keymap.set("n", "<space>bb", require("user.utils.finder").switch_buffer, {
				silent = true,
				desc = "Switch buffer with fuzzy finder",
			})

			vim.keymap.set("n", "<space>ff", require("user.utils.finder").find_files, {
				silent = true,
				desc = "Search for files with fuzzy finder",
			})

			vim.keymap.set("n", "<space>fh", require("user.utils.finder").recent_files, {
				silent = true,
				desc = "Search for files from editing history with fuzzy finder",
			})

			vim.keymap.set("n", "<space>fc", require("user.utils.finder").edit_config, {
				silent = true,
				desc = "Search for config files with fuzzy finder",
			})

			vim.keymap.set("n", "<space>fd", require("user.utils.finder").edit_dotfiles, {
				silent = true,
				desc = "Search for dotfiles with fuzzy finder",
			})

			vim.keymap.set("n", "<space>f<C-t>", require("user.utils.finder").filetypes, {
				silent = true,
				desc = "Search for filetypes with fuzzy finder",
			})

			vim.keymap.set("n", "<space>ss", require("user.utils.finder").search, {
				silent = true,
				desc = "Search for a string with fuzzy finder",
			})

			vim.keymap.set("n", "<space>s<C-s>", require("user.utils.finder").snippets, {
				silent = true,
				desc = "Search for snippets with fuzzy finder",
			})

			vim.keymap.set("n", "<space>sa", require("user.utils.finder").grep_string, {
				silent = true,
				desc = "Search for the string under cursor with fuzzy finder",
			})

			vim.keymap.set("n", "<space>sk", require("user.utils.finder").keymaps, {
				silent = true,
				desc = "Search for keymaps with fuzzy finder",
			})

			vim.keymap.set("n", "<space>s<C-h>", require("user.utils.finder").heading, {
				silent = true,
				desc = "Search for heading with fuzzy finder",
			})

			vim.keymap.set("n", "<space>sh", require("user.utils.finder").help_tags, {
				silent = true,
				desc = "Search for help info with fuzzy finder",
			})

			vim.keymap.set("n", "<space>vf", require("telescope.builtin").git_files, {
				silent = true,
				desc = "Search for tracked files with fuzzy finder",
			})

			vim.keymap.set("n", "<space>v<C-f>", require("telescope.builtin").git_status, {
				silent = true,
				desc = "Search for modified files with fuzzy finder",
			})

			vim.keymap.set("n", "<space>sm", require("user.utils.finder").man_pages, {
				silent = true,
				desc = "Search for manual pages with fuzzy finder",
			})

			vim.keymap.set("n", "gz", require("user.utils.finder").zoxide, {
				silent = true,
				desc = "Change into frequently used directory with fuzzy finder",
			})
		end,
		dependencies = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "crispgm/telescope-heading.nvim" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
			{ "smartpde/telescope-recent-files" },
			{ "jvgrootveld/telescope-zoxide" },
			{ "benfowler/telescope-luasnip.nvim" },
		},
	},
}
