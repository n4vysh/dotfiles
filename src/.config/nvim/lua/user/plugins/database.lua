return {
	{
		"kristijanhusak/vim-dadbod-ui",
		-- NOTE: call from shell
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		keys = {
			{
				"g<C-d>",
				":DBUI<CR>",
				silent = true,
				desc = "Toggle UI for database",
			},
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_use_nvim_notify = 1
			vim.g.db_ui_save_location = "~/Documents/sql/"
			vim.g.db_ui_table_helpers = {
				postgres = {
					["Order by id desc"] = 'select * from {optional_schema}"{table}" ORDER BY id DESC LIMIT 200',
				},
				mysql = {
					["Order by id desc"] = "SELECT * from {optional_schema}`{table}` ORDER BY id DESC LIMIT 200",
				},
			}
			do
				local augroup = "dadbod_ui_no_fold"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = augroup,
					pattern = { "dbout", "sql" },
					callback = function()
						vim.opt_local.foldenable = false
					end,
				})
			end
			vim.api.nvim_set_hl(0, "NotificationInfo", {
				bg = "NONE",
			})
			do
				local augroup = "dadbod_completion"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = augroup,
					pattern = { "sql", "mysql", "plsql" },
					callback = function()
						require("cmp").setup.buffer({
							sources = { { name = "vim-dadbod-completion" } },
						})
					end,
				})
			end
		end,
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "tpope/vim-dotenv" },
			{ "rcarriga/nvim-notify" },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
	},
}
