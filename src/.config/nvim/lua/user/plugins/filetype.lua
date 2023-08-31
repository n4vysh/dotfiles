-- Language specific
-- filetype detection, Syntax highlighting, completions, etc.
return {
	{
		"NoahTheDuke/vim-just",
		ft = { "just" },
	},
	{
		"direnv/direnv.vim",
		config = function()
			vim.keymap.set("n", "<space>ee", vim.cmd.EditEnvrc, {
				silent = true,
				desc = "Edit .envrc",
			})
		end,
	},
	{
		"towolf/vim-helm",
		ft = { "helm" },
	},
	{
		"MTDL9/vim-log-highlighting",
		ft = { "log" },
	},
	{
		"google/vim-jsonnet",
		ft = { "jsonnet" },
	},
	{
		"jamespeapen/swayconfig.vim",
		ft = { "swayconfig" },
	},
	{
		"chrisbra/csv.vim",
		ft = { "csv" },
		init = function()
			vim.g.csv_no_conceal = 1
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"](0)
		end,
		config = function()
			vim.keymap.set("n", "g<C-p>", vim.fn["mkdp#util#toggle_preview"], {
				silent = true,
				desc = "Preview markdown on browser",
			})
		end,
	},

	{
		"rafcamlet/nvim-luapad",
		cmd = "Luapad",
		dependencies = "antoinemadec/FixCursorHold.nvim",
	},
}
