return {
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	},
	{
		"tpope/vim-projectionist",
		config = function()
			vim.keymap.set("n", "<Space>aa", ":A<cr>", {
				silent = true,
				desc = "Edit the alternate file for the current buffer",
			})

			vim.keymap.set("n", "<Space>as", ":AS<cr>", {
				silent = true,
				desc = "Edit the alternate file in a split",
			})

			vim.keymap.set("n", "<Space>av", ":AV<cr>", {
				silent = true,
				desc = "Edit the alternate file in a vertical split",
			})

			vim.keymap.set("n", "<Space>od", ":Edoc<cr>", {
				silent = true,
				desc = "Open the doc file",
			})

			vim.keymap.set("n", "<Space>o<c-d>", ":Edoc ", {
				silent = true,
				desc = "Open doc files",
			})

			vim.keymap.set("n", "<Space>or", ":Erunner<cr>", {
				silent = true,
				desc = "Open the runner file",
			})
		end,
	},
}
