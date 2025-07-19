-- NOTE: call functions from keymap and dashboard button
local M = {}

function M.edit_config()
	local builtin = require("telescope.builtin")
	builtin.git_files({
		use_git_root = false,
		cwd = os.getenv("XDG_DATA_HOME") .. "/chezmoi/src/dot_config/nvim/",
	})
end

function M.search(opts)
	local telescope = require("telescope")
	telescope.load_extension("live_grep_args")
	telescope.extensions.live_grep_args.live_grep_args(opts)
end

function M.recent_files()
	local telescope = require("telescope")
	telescope.load_extension("recent_files")
	telescope.extensions.recent_files.pick({})
end

return M
