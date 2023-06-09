vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.skip_loading_mswin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = "\\"

local lazy = require("lazy")

local kv = {
	clean = {
		lhs = "<C-c>",
		desc = "Remove any disabled or unused plugins",
	},
	sync = {
		lhs = "s",
		desc = "Remove and update plugins",
	},
	home = {
		lhs = "p",
		desc = "Show loaded state of plugins",
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
	rtp = {
		disabled_plugins = {
			"2html_plugin",
			"getscript",
			"getscriptPlugin",
			"gzip",
			"matchit",
			"rrhelper",
			"spellfile_plugin",
			"tar",
			"tarPlugin",
			"tutor_mode_plugin",
			"vimball",
			"vimballPlugin",
			"zip",
			"zipPlugin",
			"netrw",
			"netrwPlugin",
		},
	},
	change_detection = {
		notify = false,
	},
})

require("user.options")
require("user.autocmds")
require("user.keymaps")
if pcall(require, "user.local") then
	require("user.local")
end
