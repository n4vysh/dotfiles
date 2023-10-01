return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
		init = function()
			vim.keymap.set("n", "<Space>ft", function()
				if vim.fn.expand("%") == "" then
					vim.cmd.NvimTreeToggle()
				else
					vim.cmd.NvimTreeFindFile()
				end
			end)
		end,
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
	},
}
