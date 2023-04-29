return {
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()
			require("nvim-dap-virtual-text").setup()
			require("dap-go").setup()

			vim.api.nvim_set_hl(0, "DapBreakpoint", {
				fg = "#f7768e",
			})
			vim.api.nvim_set_hl(0, "DapLogPoint", {
				fg = "#7aa2f7",
			})
			vim.api.nvim_set_hl(0, "DapStopped", {
				fg = "#7dcfff",
			})

			vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })

			require("dap").listeners.before["event_initialized"]["custom"] = function()
				require("dapui").open()
			end
			require("dap").listeners.before["event_terminated"]["custom"] = function()
				require("dapui").close()
			end

			vim.keymap.set("n", "<space>db", require("dap").toggle_breakpoint, {
				silent = true,
			})

			vim.keymap.set("n", "<space>dd", require("dapui").toggle, {
				silent = true,
				desc = "Toggle UI for debugger",
			})

			vim.keymap.set("n", "<space>dc", require("dap").continue, {
				silent = true,
			})

			vim.keymap.set("n", "<space>ds", require("dap").step_over, {
				silent = true,
			})

			vim.keymap.set("n", "<space>d<C-s>", require("dap").step_into, {
				silent = true,
			})
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
