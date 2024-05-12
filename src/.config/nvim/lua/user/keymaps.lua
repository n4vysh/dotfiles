-- NOTE: avoid remove trailing space when going into normal mode
-- https://github.com/neovim/neovim/issues/21525
vim.keymap.set("i", "<Esc>", "<left><right><Esc>", {
	silent = true,
	desc = nil,
})

vim.keymap.set("n", "<C-s>", "<cmd>write<CR>", {
	silent = true,
	desc = "Save the current file",
})

vim.keymap.set("n", "g<C-s>", "<cmd>wall<CR>", {
	silent = true,
	desc = "Save all changed files",
})

vim.keymap.set("n", "<C-w><C-q>", "<cmd>quit!<CR>", {
	silent = true,
	desc = "Quit without writing",
})

vim.keymap.set("n", "<C-q>", "<cmd>qa<CR>", {
	silent = true,
	desc = "Quit all buffer",
})

vim.keymap.set("x", "y", "y`]", {
	silent = true,
	desc = "Put and jump the text",
})

vim.keymap.set("n", "p", "p`]", {
	silent = true,
	desc = "Put and jump the text",
})

vim.keymap.set("x", "p", "pgvy`]", {
	silent = true,
	desc = "Put and yank the text",
})

vim.keymap.set("i", "<C-x>a", " && ", {
	silent = true,
	desc = "Append and operator",
})

vim.keymap.set("i", "<C-x>o", " || ", {
	silent = true,
	desc = "Append or operator",
})

vim.keymap.set("i", "<C-x>c", " ?  : <ESC>hhi", {
	silent = true,
	desc = "Append conditional operator",
})

-- keymaps using the g
vim.keymap.set("n", "g<C-e>", "<cmd>edit!<cr>", {
	silent = true,
	desc = "Reload current buffer",
})

vim.keymap.set("n", "g<C-n>", "<cmd>enew<cr>", {
	silent = true,
	desc = "Create new buffer",
})

vim.keymap.set("n", "g<C-w><C-n>", "<cmd>vnew<cr>", {
	silent = true,
	desc = "Create new buffer in vertically split",
})

vim.keymap.set("v", "g/", [[<ESC>/\%V]], {
	desc = "Search forward in the range",
})

vim.keymap.set("v", "g?", [[<ESC>?\%V]], {
	desc = "Search backward in the range",
})

-- keymaps like VS Code
vim.keymap.set("n", "<C-h>", ":%s///g<left><left><left>", {
	desc = "Set command for substitute",
})

vim.keymap.set("v", "<C-h>", ":s///g<left><left><left>", {
	desc = "Set command for substitute",
})

-- keymaps using the space bar like Spacemacs
-- +yank
vim.keymap.set("n", "<space>yn", function()
	require("user.utils.yank").exec("file name", vim.fn.expand("%:t"))
end, {
	silent = true,
	desc = "Yank file name",
})

vim.keymap.set("n", "<space>yr", function()
	require("user.utils.yank").exec("relative path", vim.fn.expand("%:~:."))
end, {
	silent = true,
	desc = "Yank relative path",
})

vim.keymap.set("n", "<space>yf", function()
	require("user.utils.yank").exec("full path", vim.fn.expand("%:p"))
end, {
	silent = true,
	desc = "Yank full path",
})

vim.keymap.set("n", "<space>yd", function()
	require("user.utils.yank").exec("directory path", vim.fn.expand("%:h"))
end, {
	silent = true,
	desc = "Yank directory path",
})
