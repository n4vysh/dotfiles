return {
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				menu = {
					width = vim.api.nvim_win_get_width(0) - 4,
				},
				global_settings = {
					mark_branch = true,
				},
			})

			vim.keymap.set("n", "<Space>ma", require("harpoon.mark").add_file, {
				silent = true,
				desc = "Add file to mark per project",
			})

			vim.keymap.set("n", "<Space>ml", require("harpoon.ui").toggle_quick_menu, {
				silent = true,
				desc = "List marks of project",
			})

			vim.keymap.set("n", "<space>mm", require("user.utils.finder").harpoon, {
				silent = true,
				desc = "Search for marks per project with fuzzy finder",
			})
		end,
	},
}
