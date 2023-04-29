do
	local auname = "im"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = auname,
		pattern = "*",
		callback = require("user.utils.im").disable,
	})
end

do
	local auname = "skel"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("BufNewFile", {
		group = auname,
		pattern = "*.*",
		callback = require("user.utils.skel").load,
	})
end

do
	local auname = "autoread"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("FocusGained", {
		group = auname,
		pattern = "*",
		callback = function()
			vim.cmd([[checktime]])
		end,
	})
end

do
	local auname = "buflisted"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = auname,
		pattern = { "qf", "man", "dap-repl" },
		callback = function()
			vim.opt_local.buflisted = false
		end,
	})
end

-- appearance
do
	local auname = "highlight_yank"
	vim.api.nvim_create_augroup(auname, { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = auname,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	})
end
