local M = {}

function M.find_files()
	local builtin = require("telescope.builtin")
	builtin.find_files({})
end

function M.git_files()
	local builtin = require("telescope.builtin")
	builtin.git_files({})
end

function M.edit_config()
	local builtin = require("telescope.builtin")
	builtin.git_files({
		use_git_root = false,
		cwd = os.getenv("XDG_DATA_HOME") .. "/dotfiles/src/.config/nvim/",
	})
end

function M.edit_dotfiles()
	local builtin = require("telescope.builtin")
	builtin.git_files({
		cwd = os.getenv("XDG_DATA_HOME") .. "/dotfiles/src/",
	})
end

function M.file_browser()
	require("telescope").load_extension("file_browser")
	require("telescope").extensions.file_browser.file_browser()
end

function M.switch_buffer()
	local builtin = require("telescope.builtin")
	builtin.buffers({})
end

function M.search(opts)
	local telescope = require("telescope")
	telescope.load_extension("live_grep_args")
	telescope.extensions.live_grep_args.live_grep_args(opts)
end

function M.snippets()
	local telescope = require("telescope")
	telescope.load_extension("luasnip")
	telescope.extensions.luasnip.luasnip({})
end

function M.help_tags()
	local builtin = require("telescope.builtin")
	builtin.help_tags({})
end

function M.keymaps()
	local builtin = require("telescope.builtin")
	builtin.keymaps({})
end

function M.man_pages()
	local builtin = require("telescope.builtin")
	builtin.man_pages()
end

function M.grep_string()
	local builtin = require("telescope.builtin")
	builtin.grep_string({})
end

function M.recent_files()
	local telescope = require("telescope")
	telescope.load_extension("recent_files")
	telescope.extensions.recent_files.pick({})
end

function M.harpoon()
	local telescope = require("telescope")
	telescope.load_extension("harpoon")
	telescope.extensions.harpoon.marks({})
end

return M
