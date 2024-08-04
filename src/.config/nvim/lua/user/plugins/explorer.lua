return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
		keys = {
			{
				"<Space>ft",
				function()
					if vim.fn.expand("%") == "" then
						vim.cmd.NvimTreeToggle()
					else
						vim.cmd.NvimTreeFindFile()
					end
				end,
				desc = "Toggle file tree",
			},
		},
		opts = {
			hijack_cursor = true,
			hijack_netrw = false,
			view = {
				float = {
					enable = false,
				},
			},
			filters = {
				git_ignored = false,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
			},
		},
		dependencies = {
			"stevearc/dressing.nvim",
		},
	},
}
