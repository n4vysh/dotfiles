local options = {
	undofile = true,
	completeopt = { "menuone", "noinsert", "noselect" },
	ignorecase = true,
	smartcase = true,
	wildignorecase = true,
	smartindent = true,
	tabstop = 2,
	softtabstop = -1,
	shiftwidth = 0,
	expandtab = true,
	-- appearance
	splitbelow = true,
	splitright = true,
	splitkeep = "topline",
	laststatus = 3,
	cursorline = true,
	number = true,
	showmatch = true,
	matchtime = 1,
	showcmd = false,
	showmode = false,
	signcolumn = "yes",
	pumheight = 10,
	showbreak = "↪ ",
	list = true,
	fillchars = {
		diff = "╱",
		horiz = "━",
		horizup = "┻",
		horizdown = "┳",
		vert = "┃",
		vertleft = "┫",
		vertright = "┣",
		verthoriz = "╋",
		fold = " ",
		foldopen = "",
		foldsep = " ",
		foldclose = "",
	},
	foldcolumn = "1",
	foldlevel = 99,
	foldlevelstart = 99,
	foldenable = true,
	-- https://github.com/ray-x/lsp_signature.nvim/issues/255
	updatetime = 500,
}

if vim.g.neovide then
	-- NOTE: status bar grayed out when enable transparency
	--        https://github.com/neovide/neovide/issues/2275
	--
	-- vim.g.neovide_transparency = 0.6
	-- vim.g.transparency = 0.6

	vim.g.neovide_cursor_vfx_mode = "sonicboom"
	vim.g.neovide_padding_top = 13
	vim.g.neovide_padding_bottom = 13
	vim.g.neovide_padding_right = 15
	vim.g.neovide_padding_left = 15

	options = vim.tbl_extend("force", options, {
		-- NOTE: powerline symbols misaligned when set guifont
		-- https://github.com/neovide/neovide/issues/2491
		-- guifont = "Fira Code,Symbols Nerd Font Mono,Noto Sans Mono CJK JP,Noto Sans Symbols,Noto Sans Math",
	})
end

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.wildmode:prepend({ "longest:full" })
vim.opt.shortmess:append({ IcasW = true })
vim.opt.listchars:append({
	tab = "▏·",
	trail = "˽",
	eol = "¬",
	extends = "»",
	precedes = "«",
	nbsp = "⍽",
})

vim.opt.clipboard = "unnamedplus"

-- selene: allow(empty_if)
if vim.env.WSL_DISTRO_NAME ~= nil then
	-- NOTE: use wl-copy and wl-paste when WSL
elseif vim.env.WAYLAND_DISPLAY ~= nil then
	vim.g.clipboard = {
		name = "OSC 52 and wl-paste",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = { "wl-paste", "--no-newline" },
			["*"] = { "wl-paste", "--no-newline", "--primary" },
		},
	}
else
	local function paste()
		return {
			vim.fn.split(vim.fn.getreg(""), "\n"),
			vim.fn.getregtype(""),
		}
	end

	vim.g.clipboard = {
		name = "OSC 52 copy only",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}
end

vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

vim.filetype.add({
	extension = {
		-- HACK: detect with terraform-ls and tree-sitter-terraform
		tf = "terraform",
	},
	pattern = {
		[".*/.*%.rasi"] = "rasi",
		[".*/%.zshrc.d/functions/.*"] = "zsh",
		[".*/%.config/hypr/.*%.conf"] = "hyprlang",
		[".*/%.config/git/config%..*"] = "gitconfig",
		[".*/%.config/swappy/config"] = "ini",
		[".*/%.config/waybar/config"] = "json",
		[".*/%.czrc"] = "json",
		[".*/%.config/yamllint/config"] = "yaml",
		[".*/helmfile.d/.*%.ya?ml"] = "helm",
		[".*/helmfile.d/.*/.*%.ya?ml"] = "helm",
		-- for sudoedit
		["/var/tmp/passwd%..*"] = "passwd",
		["/var/tmp/shadow%..*"] = "passwd",
		-- for compose-language-service
		[".*/compose%.ya?ml"] = "yaml.docker-compose",
		[".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
	},
})
