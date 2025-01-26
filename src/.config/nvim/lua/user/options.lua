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
	winblend = 15,
	pumblend = 30,
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
	},
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
	trail = "˽",
	eol = "¬",
	extends = "»",
	precedes = "«",
	nbsp = "⍽",
})

if vim.env.DISPLAY ~= "" then
	vim.opt.clipboard = "unnamedplus"
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.filetype.add({
	extension = {
		-- HACK: detect with terraform-ls and tree-sitter-terraform
		tf = "terraform",
		-- HACK: avoid E5248
		-- https://github.com/neovim/nvim-lspconfig/issues/2685
		tfvars = "hcl",
	},
	pattern = {
		[".*/.*%.rasi"] = "rasi",
		[".*/%.config/hypr/.*%.conf"] = "hyprlang",
		[".*/%.config/git/config%..*"] = "gitconfig",
		[".*/%.config/swappy/config"] = "ini",
		[".*/%.config/waybar/config"] = "json",
		[".*/%.config/yamllint/config"] = "yaml",
		-- for sudoedit
		["/var/tmp/passwd%..*"] = "passwd",
		["/var/tmp/shadow%..*"] = "passwd",
		-- for compose-language-service
		[".*/compose%.ya?ml"] = "yaml.docker-compose",
		[".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
	},
})
