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
			end, {
				silent = true,
				desc = "Toggle file tree",
			})
		end,
		config = function()
			require("nvim-tree").setup({
				hijack_cursor = true,
				hijack_netrw = false,
			})
		end,
	},
}
