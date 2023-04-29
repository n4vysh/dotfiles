return {
	{
		"nvim-neotest/neotest",
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
					}),
					require("neotest-vim-test")({
						allow_file_types = { "bash" },
					}),
				},
			})

			vim.keymap.set("n", "[<C-t>", function()
				require("neotest").jump.prev({ status = "failed" })
			end, {
				silent = true,
			})

			vim.keymap.set("n", "]<C-t>", function()
				require("neotest").jump.next({ status = "failed" })
			end, {
				silent = true,
			})

			vim.keymap.set("n", "<space>tt", function()
				require("neotest").run.run()
			end, {
				silent = true,
			})

			vim.keymap.set("n", "<space>t<C-t>", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, {
				silent = true,
			})

			vim.keymap.set("n", "<space>to", function()
				require("neotest").output.open()
			end, {
				silent = true,
			})

			vim.keymap.set("n", "<space>ts", function()
				require("neotest").summary.toggle()
			end, {
				silent = true,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-vim-test",
			"vim-test/vim-test",
		},
	},
}
