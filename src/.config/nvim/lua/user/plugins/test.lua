return {
	{
		"nvim-neotest/neotest",
		keys = {
			{
				"[f",
				function()
					require("neotest").jump.prev({ status = "failed" })
				end,
				silent = true,
				desc = "Jump previous failed",
			},
			{
				"]f",
				function()
					require("neotest").jump.next({ status = "failed" })
				end,
				silent = true,
				desc = "Jump next failed",
			},
			{
				"<space>tt",
				function()
					require("neotest").run.run()
				end,
				silent = true,
				desc = "Run test",
			},
			{
				"<space>tc",
				function()
					require("coverage").load()
					require("coverage").show()
					require("coverage").summary()
				end,
				silent = true,
				desc = "Show coverage summary",
			},
			{
				"<space>tb",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				silent = true,
				desc = "Run test in current buffer",
			},
			{
				"<space>to",
				function()
					require("neotest").output.open()
				end,
				silent = true,
				desc = "Open test output",
			},
			{
				"<space>ts",
				function()
					require("neotest").summary.toggle()
				end,
				silent = true,
				desc = "Toggle test summary",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						args = { "-coverprofile=coverage.out" },
						experimental = {
							test_table = true,
						},
					}),
					require("neotest-vim-test")({
						allow_file_types = { "bash" },
					}),
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-vim-test",
			"vim-test/vim-test",
			{
				"andythigpen/nvim-coverage",
				opts = {
					auto_reload = true,
				},
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
		},
	},
}
