return {
	{
		"rcarriga/nvim-dap-ui",
		keys = {
			{
				"<space>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				silent = true,
				desc = "Toggle breakpoint for debugger",
			},
			{
				"<space>dd",
				function()
					require("dapui").toggle()
				end,
				silent = true,
				desc = "Toggle UI for debugger",
			},
			{
				"<space>dc",
				function()
					require("dap").continue()
				end,
				silent = true,
				desc = "Continue execution for debugger",
			},
			{
				"<space>di",
				function()
					require("dap").step_into()
				end,
				silent = true,
				desc = "Requests the debugger to step into",
			},
			{
				"<space>do",
				function()
					require("dap").step_over()
				end,
				silent = true,
				desc = "Requests the debugger to step over",
			},
		},
		config = function()
			require("dapui").setup()
			require("nvim-dap-virtual-text").setup({})
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

			vim.fn.sign_define("DapBreakpoint", {
				text = "•",
				texthl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "",
				texthl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "",
				texthl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", numhl = "DapStopped" }
			)

			require("dap").listeners.before["event_initialized"]["custom"] = function()
				require("dapui").open()
			end
			require("dap").listeners.before["event_terminated"]["custom"] = function()
				require("dapui").close()
			end
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
