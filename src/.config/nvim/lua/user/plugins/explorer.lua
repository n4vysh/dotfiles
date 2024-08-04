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
				icons = {
					git_placement = "right_align",
					modified_placement = "right_align",
					diagnostics_placement = "right_align",
					bookmarks_placement = "right_align",
					padding = " ",
					show = {
						file = true,
						folder = true,
						diagnostics = true,
						bookmarks = true,
						git = true,
						modified = true,
					},
				},
			},
		},
		dependencies = {
			"stevearc/dressing.nvim",
		},
	},
}
