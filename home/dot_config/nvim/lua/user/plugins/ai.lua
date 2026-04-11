return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
			},
			filetypes = {
				lua = true,
				go = true,
				typescript = true,
				["*"] = false,
			},
		},
	},
	{
		"folke/sidekick.nvim",
		keys = {
			{
				"<tab>",
				function()
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>"
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
		},
		opts = {},
	},
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		keys = {
			{
				"<space>aa",
				function()
					require("opencode").ask("@this: ", { submit = true })
				end,
				desc = "Ask AI",
				mode = { "n", "x" },
			},
			{
				"<space>an",
				function()
					require("opencode").command("session.new")
				end,
				desc = "Start new chat session for AI",
				mode = { "n", "x" },
			},
			{
				"<space>ah",
				function()
					require("opencode").select_session()
				end,
				desc = "Opens chat sessions for AI",
				mode = { "n", "x" },
			},
			{
				"<C-.>",
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle sidebar for AI",
				mode = { "n", "t" },
			},
			{
				"<C-M-u>",
				function()
					require("opencode").command("session.half.page.up")
				end,
				desc = "Scroll up chat session for AI",
				mode = "n",
			},
			{
				"<C-M-d>",
				function()
					require("opencode").command("session.half.page.down")
				end,
				desc = "Scroll down chat session for AI",
				mode = "n",
			},
		},
		config = function()
			local opencode_cmd = "opencode --port"
			---@type snacks.terminal.Opts
			local snacks_terminal_opts = {
				win = {
					position = "right",
					enter = false,
					on_win = function(win)
						require("opencode.terminal").setup(win.win)
					end,
				},
			}
			---@type opencode.Opts
			vim.g.opencode_opts = {
				server = {
					start = function()
						require("snacks.terminal").open(
							opencode_cmd,
							snacks_terminal_opts
						)
					end,
					stop = function()
						require("snacks.terminal")
							.get(opencode_cmd, snacks_terminal_opts)
							:close()
					end,
					toggle = function()
						require("snacks.terminal").toggle(
							opencode_cmd,
							snacks_terminal_opts
						)
					end,
				},
			}
		end,
		dependencies = {
			{
				---@module "snacks"
				"folke/snacks.nvim",
				optional = true,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode").snacks_picker_send(
									...
								)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = {
										"opencode_send",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				},
			},
		},
	},
}
