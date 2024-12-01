vim.keymap.set("i", "<C-v>", "<C-r>+", {
	silent = true,
	desc = "Paste from clipboard",
})

-- NOTE: avoid remove trailing space when going into normal mode
-- https://github.com/neovim/neovim/issues/21525
vim.keymap.set("i", "<Esc>", "<left><right><Esc>", {
	silent = true,
	desc = nil,
})

vim.keymap.set(
	"n",
	"<C-l>",
	-- NOTE: lua function is not work
	[[<cmd>nohlsearch|diffupdate|normal! <C-l><CR><cmd>silent! Fidget suppress<CR><cmd>silent! lua require("notify").dismiss()<CR>]],
	{
		silent = true,
		desc = "Redraws the screen and toggle some interface",
	}
)

vim.keymap.set({ "i" }, "<C-r><C-r>", "<C-r>+", {
	silent = true,
	desc = nil,
})

vim.keymap.set({ "s" }, "<C-r><C-r>", "<C-g>p", {
	silent = true,
	desc = nil,
})

vim.keymap.set({ "o", "x" }, "i<space>", "iW", {
	silent = true,
	desc = nil,
})

vim.keymap.set({ "o", "x" }, "a<space>", "aW", {
	silent = true,
	desc = nil,
})

vim.keymap.set({ "v" }, "v", "V", {
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

if vim.g.neovide then
	vim.keymap.set({ "n", "v" }, "<C-=>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
	end, {
		silent = true,
		desc = "Increase font size",
	})
	vim.keymap.set({ "n", "v" }, "<C-->", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
	end, {
		silent = true,
		desc = "Decrease font size",
	})
	vim.keymap.set({ "n", "v" }, "<C-0>", function()
		vim.g.neovide_scale_factor = 1
	end, {
		silent = true,
		desc = "Reset font size",
	})
end

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

-- keymaps using the g like helix
vim.keymap.set({ "n", "v", "o" }, "ge", "G", {
	silent = true,
	desc = "Goto last line",
})

vim.keymap.set({ "n", "v", "o" }, "gh", "0", {
	silent = true,
	desc = "Goto line start",
})

vim.keymap.set({ "n", "o" }, "gl", "$", {
	silent = true,
	desc = "Goto line end",
})

vim.keymap.set({ "v" }, "gl", "$h", {
	silent = true,
	desc = "Goto line end",
})

vim.keymap.set({ "n", "v", "o" }, "gs", "^", {
	silent = true,
	desc = "Goto first non-blank in line",
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
