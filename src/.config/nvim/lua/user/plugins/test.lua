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
					-- https://github.com/nvim-neotest/neotest/discussions/197
					require("neotest").summary.toggle()
					vim.defer_fn(function()
						---@diagnostic disable-next-line: param-type-mismatch
						local win = vim.fn.bufwinid("Neotest Summary")
						if win > -1 then
							vim.api.nvim_set_current_win(win)
						end
					end, 101)
				end,
				silent = true,
				desc = "Toggle test summary",
			},
		},
		config = function()
			require("neotest").setup({
				icons = {
					expanded = "┐",
					final_child_prefix = "└",
					running_animated = {
						"⠋",
						"⠙",
						"⠹",
						"⠸",
						"⠼",
						"⠴",
						"⠦",
						"⠧",
						"⠇",
						"⠏",
					},
				},
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

			do
				local augroup = "neotest_close_mappings"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				for _, ft in ipairs({ "output", "attach", "summary" }) do
					vim.api.nvim_create_autocmd("FileType", {
						group = augroup,
						pattern = "neotest-" .. ft,
						callback = function(opts)
							vim.keymap.set("n", "q", function()
								pcall(vim.api.nvim_win_close, 0, true)
							end, {
								buffer = opts.buf,
							})
						end,
					})
				end
			end
		end,
		dependencies = {
			"nvim-neotest/nvim-nio",
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
