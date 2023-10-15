return {
	{
		"kristijanhusak/vim-dadbod-ui",
		-- NOTE: call from shell
		cmd = { "DBUI" },
		keys = {
			{ "g<C-d>", ":DBUI<CR>", silent = true, desc = "Toggle UI for database" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
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
				local auname = "dadbod_ui_no_fold"
				vim.api.nvim_create_augroup(auname, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = auname,
					pattern = "dbout",
					callback = function()
						vim.opt_local.foldenable = false
					end,
				})
			end
			vim.api.nvim_set_hl(0, "NotificationInfo", {
				bg = "NONE",
			})
			do
				local auname = "dadbod_completion"
				vim.api.nvim_create_augroup(auname, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = auname,
					pattern = { "sql", "mysql", "plsql" },
					callback = function()
						require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
					end,
				})
			end
		end,
		dependencies = {
			{ "tpope/vim-dadbod" },
			{ "tpope/vim-dotenv" },
			{ "kristijanhusak/vim-dadbod-completion" },
		},
	},
}
