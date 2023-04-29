-- Browser Integration
return {
	{
		"subnut/nvim-ghost.nvim",
		build = function()
			vim.fn["nvim_ghost#installer#install"]()
		end,
		init = function()
			vim.g.nvim_ghost_super_quiet = 1
		end,
	},
	{
		"tyru/open-browser.vim",
		init = function()
			vim.g.netrw_nogx = 1
		end,
		config = function()
			vim.keymap.set({ "n", "v" }, "gx", "<Plug>(openbrowser-smart-search)", {
				silent = true,
			})
		end,
	},
}
