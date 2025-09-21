-- Language specific
-- filetype detection, Syntax highlighting, completions, etc.
return {
	{
		"tridactyl/vim-tridactyl",
		ft = "tridactyl",
	},
	{
		"yanskun/gotests.nvim",
		ft = "go",
		keys = {
			{
				"<space>tg",
				vim.cmd.GoTests,
				silent = true,
				desc = "Generate test",
			},
		},
		opts = {},
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
		keys = {
			{
				"g<C-p>",
				vim.fn["mkdp#util#toggle_preview"],
				silent = true,
				desc = "Preview markdown on browser",
			},
		},
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
		config = function()
			vim.cmd("silent TableModeToggle")
		end,
	},
	{
		"rafcamlet/nvim-luapad",
		cmd = "Luapad",
		dependencies = "antoinemadec/FixCursorHold.nvim",
	},
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
			vim.g["chezmoi#source_dir_path"] = vim.fn.expand("~")
				.. "/.local/share/chezmoi/src"

			do
				local augroup = "chezmoi"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = augroup,
					pattern = {
						vim.fn.expand("~")
							.. "/.local/share/chezmoi/src/*dot_*",
					},
					command = "silent !chezmoi apply --source-path %",
				})
			end
		end,
	},
}
