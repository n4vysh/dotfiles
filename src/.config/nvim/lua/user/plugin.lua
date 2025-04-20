vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.skip_loading_mswin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

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

lazy.setup({
	spec = {
		{ import = "user.plugins" },
	},
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
