do
	local augroup = "im"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = augroup,
		pattern = "*",
		callback = require("user.utils.im").disable,
	})
end

do
	local augroup = "skel"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("BufNewFile", {
		group = augroup,
		pattern = "*.*",
		callback = require("user.utils.skel").load,
	})
end

do
	local augroup = "autoread"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("FocusGained", {
		group = augroup,
		pattern = "*",
		callback = function()
			vim.cmd([[checktime]])
		end,
	})
end

do
	local augroup = "buflisted"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = { "qf", "man", "dap-repl" },
		callback = function()
			vim.opt_local.buflisted = false
		end,
	})
end

do
	local augroup = "delete_directory"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = { "*" },
		callback = function()
			local v = vim.fn.expand("%")
			if vim.fn.isdirectory(v) ~= 0 then
				vim.api.nvim_echo({ { "Delete directory from buffer list: " .. v .. "\n", "WarningMsg" } }, true, {})
				vim.cmd.bw(v)
			end
		end,
	})
end

do
	local augroup = "indent_for_empty_buffer"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = augroup,
		pattern = "*",
		callback = function()
			if vim.bo.filetype == "" then
				vim.opt_local.expandtab = true
			end
		end,
	})
end

-- appearance
do
	local augroup = "highlight_yank"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroup,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	})
end
