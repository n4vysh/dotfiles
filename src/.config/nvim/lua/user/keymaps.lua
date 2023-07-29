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

vim.keymap.set("n", "<C-c>", "<Nop>", {
	desc = "Remap for plugin",
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

-- keymaps using the space bar like Spacemacs
-- +commands
vim.keymap.set("n", "<space>ca", ":%!awk '{print $}'<left><left>", { desc = "Set command for awk to command-line" })

vim.keymap.set("v", "<space>ca", ":!awk '{print $}'<left><left>", { desc = "Set command for awk to command-line" })

vim.keymap.set("n", "<space>c<C-a>", ":args ", { desc = "Set command for args to command-line" })

vim.keymap.set("n", "<space>cs", ":%s///g<left><left><left>", {
	desc = "Set command for substitute to command-line",
})

vim.keymap.set("v", "<space>cs", ":s///g<left><left><left>", {
	desc = "Set command for substitute to command-line",
})

-- +open
vim.keymap.set("n", "<Space>ot", "<cmd>edit ~/Documents/tasks.md<cr>", {
	silent = true,
	desc = "Open task file",
})

vim.keymap.set("n", "<Space>on", "<cmd>edit ~/Documents/note.md<cr>", {
	silent = true,
	desc = "Open note",
})

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
