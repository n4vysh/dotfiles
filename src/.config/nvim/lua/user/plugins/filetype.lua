-- Language specific
-- filetype detection, Syntax highlighting, completions, etc.
return {
	{
		"yanskun/gotests.nvim",
		ft = "go",
		keys = {
			{
				"<space>tg",
				vim.cmd.GoTests,
				{
					silent = true,
					desc = "Generate test",
				},
			},
		},
		config = function()
			require("gotests").setup()
		end,
	},
	{
		"NoahTheDuke/vim-just",
		ft = { "just" },
	},
	{
		"direnv/direnv.vim",
		ft = { "direnv" },
		keys = {
			{
				"<space>ee",
				vim.cmd.EditEnvrc,
				{
					silent = true,
					desc = "Edit .envrc",
				},
			},
		},
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
		"hjson/vim-hjson",
		ft = { "hjson" },
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
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
		config = function()
			vim.cmd.TableModeToggle()
		end,
	},

	{
		"rafcamlet/nvim-luapad",
		cmd = "Luapad",
		dependencies = "antoinemadec/FixCursorHold.nvim",
	},
}
