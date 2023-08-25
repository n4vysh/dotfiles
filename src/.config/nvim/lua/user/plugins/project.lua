return {
	{
		"tpope/vim-projectionist",
		event = { "VeryLazy" },
		config = function()
			vim.keymap.set("n", "<Space>aa", ":A<cr>", {
				silent = true,
				desc = "Edit the alternate file",
			})

			vim.keymap.set("n", "<Space>as", ":AS<cr>", {
				silent = true,
				desc = "Edit the alternate file in a split",
			})

			vim.keymap.set("n", "<Space>av", ":AV<cr>", {
				silent = true,
				desc = "Edit the alternate file in a vertical split",
			})

			vim.keymap.set("n", "<Space>ed", ":Edoc<cr>", {
				silent = true,
				desc = "Edit the doc file",
			})

			vim.keymap.set("n", "<Space>er", ":Erunner<cr>", {
				silent = true,
				desc = "Edit the runner file",
			})
		end,
	},
}
