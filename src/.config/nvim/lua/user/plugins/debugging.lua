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
				"<space>dB",
				function()
					require("dap").set_breakpoint(
						vim.fn.input("Breakpoint condition: ")
					)
				end,
				silent = true,
				desc = "Set breakpoint condition for debugger",
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
				"<space>dC",
				function()
					require("dap").run_to_cursor()
				end,
				silent = true,
				desc = "Run to cursor with debugger",
			},
			{
				"<space>de",
				function()
					require("dapui").eval(
						nil,
						{ enter = true, width = 60, height = 15 }
					)
				end,
				silent = true,
				desc = "Evaluate expression with debugger",
			},
			{
				"<space>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to line (No Execute) for debugger",
			},
			{
				"<space>di",
				function()
					require("dap").step_into()
				end,
				silent = true,
				desc = "Step into with debugger",
			},
			{
				"<space>do",
				function()
					require("dap").step_over()
				end,
				silent = true,
				desc = "Step over with debugger",
			},
			{
				"<space>dO",
				function()
					require("dap").step_out()
				end,
				silent = true,
				desc = "Step out with debugger",
			},
			{
				"<space>dh",
				function()
					require("nvim-dap-virtual-text").toggle()
				end,
				silent = true,
				desc = "Show hint with debugger",
			},
			{
				"<space>dj",
				function()
					require("dap").down()
				end,
				silent = true,
				desc = "Go down in current stacktrace without stepping",
			},
			{
				"<space>dk",
				function()
					require("dap").up()
				end,
				silent = true,
				desc = "Go up in current stacktrace without stepping",
			},
			{
				"<space>dl",
				function()
					require("dap").run_last()
				end,
				silent = true,
				desc = "Re-run last session with debugger",
			},
			{
				"<space>dp",
				function()
					require("dap").pause()
				end,
				silent = true,
				desc = "Pause with debugger",
			},
			{
				"<space>dr",
				function()
					require("dap").repl.toggle()
				end,
				silent = true,
				desc = "Toggle REPL only for debugger",
			},
			{
				"<space>ds",
				function()
					require("dapui").float_element(
						"scopes",
						{ enter = true, width = 60, height = 15 }
					)
				end,
				silent = true,
				desc = "Show scopes with debugger",
			},
			{
				"<space>dt",
				function()
					require("dap").terminate()
				end,
				silent = true,
				desc = "Terminate session for debugger",
			},
			{
				"<space>dw",
				function()
					require("dapui").elements.watches.add()
				end,
				silent = true,
				desc = "Add watch expression with debugger",
			},
		},
		config = function()
			require("dapui").setup({
				expand_lines = false,
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.5,
							},
							{
								id = "watches",
								size = 0.25,
							},
							{
								id = "stacks",
								size = 0.125,
							},
							{
								id = "breakpoints",
								size = 0.125,
							},
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{
								id = "repl",
								size = 0.5,
							},
							{
								id = "console",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
			})
			require("nvim-dap-virtual-text").setup({
				enabled = false,
			})
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
				text = "",
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
				{ text = "", texthl = "DapStopped", numhl = "DapStopped" }
			)

			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-treesitter/nvim-treesitter",
			"leoluz/nvim-dap-go",
		},
	},
}
