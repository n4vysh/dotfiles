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

-- NOTE: Lua adaptation of vim-cool
-- https://www.reddit.com/r/neovim/comments/1ct2w2h/comment/l4bgvn1/
do
	local augroup = "auto_nohlsearch"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = augroup,
		callback = function()
			if
				vim.v.hlsearch == 1
				and vim.fn.searchcount().exact_match == 0
			then
				vim.schedule(function()
					vim.cmd.nohlsearch()
				end)
			end
		end,
	})
end

do
	local augroup = "wrap"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = { "AvanteInput" },
		callback = function()
			vim.opt_local.wrap = true
		end,
	})
end

do
	local augroup = "nowrap"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = { "neotest-summary" },
		callback = function()
			vim.opt_local.wrap = false
		end,
	})
end

do
	local augroup = "gopass"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		pattern = { "/dev/shm/gopass*" },
		callback = function()
			vim.opt_local.swapfile = false
			vim.opt_local.backup = false
			vim.opt_local.undofile = false
			vim.opt_local.shada = ""
		end,
	})
end

-- NOTE: remove directory buffer when buffer added
do
	local augroup = "delete_directory"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("BufAdd", {
		group = augroup,
		pattern = { "*" },
		callback = function(args)
			local bufnr = args.buf
			local v = vim.api.nvim_buf_get_name(bufnr)
			if vim.fn.isdirectory(v) ~= 0 then
				if bufnr ~= -1 then
					local success, result = pcall(function()
						vim.api.nvim_buf_delete(bufnr, { force = true })
					end)
					if success then
						vim.notify(
							"Deleted directory from buffer list: "
								.. vim.fn.fnamemodify(v, ":.")
								.. "\n",
							vim.log.levels.WARN
						)
					else
						vim.notify(
							"Failed to delete buffer for: "
								.. v
								.. ". Error: "
								.. tostring(result),
							vim.log.levels.ERROR
						)
					end
				end
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
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 50 })
		end,
	})
end
