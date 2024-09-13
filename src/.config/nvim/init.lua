vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.skip_loading_mswin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = "\\"

local lazy = require("lazy")

local kv = {
	sync = {
		lhs = "s",
		desc = "Remove and update plugins",
	},
	install = {
		lhs = "i",
		desc = "Install missing plugins",
	},
	update = {
		lhs = "u",
		desc = "Update plugins",
	},
	restore = {
		lhs = "r",
		desc = "Restore plugins",
	},
}

for k, v in pairs(kv) do
	vim.keymap.set("n", "<Space>p" .. v.lhs, lazy[k], {
		silent = true,
		desc = v.desc,
	})
end

lazy.setup("user.plugins", {
	install = {
		colorscheme = { "tokyonight" },
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"rplugin",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	change_detection = {
		notify = false,
	},
})

do
	local augroup = "lazy"
	vim.api.nvim_create_augroup(augroup, { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = "lazy",
		callback = function()
			vim.opt_local.winblend = 0
		end,
	})
end

require("user.options")
require("user.autocmds")
require("user.keymaps")
if pcall(require, "user.local") then
	require("user.local")
end

-- NOTE: remove directory buffer when startup
for _, v in ipairs(vim.fn.argv()) do
	if vim.fn.isdirectory(v) ~= 0 then
		local bufnr = vim.fn.bufnr(v)
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
end
