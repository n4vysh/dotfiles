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
			},
		},
		config = function()
			require("nvim-tree").setup({
				hijack_cursor = true,
				hijack_netrw = false,
				view = {
					float = {
						enable = false,
					},
				},
			})
		end,
		dependencies = {
			"stevearc/dressing.nvim",
		},
	},
}
