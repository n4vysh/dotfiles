local options = {
	undofile = true,
	completeopt = { "menuone", "noinsert", "noselect" },
	ignorecase = true,
	smartcase = true,
	wildignorecase = true,
	wildmode = { "longest:full", "full" },
	smartindent = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	-- appearance
	laststatus = 3,
	termguicolors = true,
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
	listchars = {
		tab = "▸ ",
		trail = "˽",
		eol = "¬",
		extends = "»",
		precedes = "«",
		nbsp = "·",
	},
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
	updatetime = 5000,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append({ Ic = true })

if vim.env.DISPLAY ~= "" then
	vim.opt.clipboard = "unnamedplus"
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
