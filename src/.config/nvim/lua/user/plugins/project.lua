return {
	{
		"ahmedkhalf/project.nvim",
		keys = {
			{ "<space>cr", "<cmd>ProjectRoot<cr>", silent = true, desc = "Change to root directory" },
		},
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	},
	{
		"tpope/vim-projectionist",
		event = { "BufReadPost", "BufNewFile" },
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
