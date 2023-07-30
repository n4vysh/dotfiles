return {
	{
		"ThePrimeagen/harpoon",
		keys = {
			{
				"<Space>ma",
				function()
					require("harpoon.mark").add_file()
				end,
				silent = true,
				desc = "Add file to mark per project",
			},
			{
				"<Space>ml",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				silent = true,
				desc = "List marks of project",
			},
			{
				"<space>mm",
				function()
					require("user.utils.finder").harpoon()
				end,
				silent = true,
				desc = "Search for marks with fuzzy finder",
			},
		},
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			global_settings = {
				mark_branch = true,
			},
		},
	},
}
