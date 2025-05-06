return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				lua = true,
				go = true,
				typescript = true,
				["*"] = false,
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		opts = {},
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		keys = {
			{
				"<space>aa",
				"<cmd>AvanteAsk<cr>",
				desc = "Show sidebar for AI",
				mode = { "n", "v" },
			},
			{
				"<space>an",
				"<cmd>AvanteChatNew<cr>",
				desc = "Start new chat session for AI",
				mode = { "n", "v" },
			},
			{
				"<space>ac",
				"<cmd>AvanteClear<cr>",
				desc = "Clear the chat history for AI",
				mode = { "n", "v" },
			},
			{
				"<space>ah",
				"<cmd>AvanteHistory<cr>",
				desc = "Opens chat sessions for AI",
				mode = { "n", "v" },
			},
			{
				"<space>ae",
				"<cmd>AvanteEdit<cr>",
				desc = "Edit selected blocks for AI",
				mode = { "v" },
			},
			{
				"<space>as",
				"<cmd>AvanteStop<cr>",
				desc = "Stop current requests for AI",
				mode = { "n" },
			},
		},
		opts = function()
			-- NOTE: use copilot as default provider to avoid Claude's API rate limits and costs
			local provider = "copilot"

			if vim.fn.exists("$BEDROCK_KEYS") == 1 then
				provider = "bedrock-claude-3.7-sonnet"
			end

			return {
				provider = provider,
				-- WARNING: always use `claude` provider
				--          `copilot` provider is expensive and dangerous
				--          https://github.com/yetone/avante.nvim/issues/1048
				auto_suggestions_provider = "claude",
				copilot = {
					model = "claude-3.7-sonnet",
				},
				hints = { enabled = false },
				selector = {
					provider = "telescope",
				},
				windows = {
					sidebar_header = {
						rounded = false,
					},
					edit = {
						border = "single",
					},
					ask = {
						border = "single",
					},
				},
				system_prompt = function()
					local hub = require("mcphub").get_hub_instance()
					return [[
						- Respond in japanese.
						- When making code comments, create it in english.
						- When making a commit, create a message in english using conventional commit format and gitmoji.

					]] .. hub:get_active_servers_prompt()
				end,
				custom_tools = function()
					return {
						require("mcphub.extensions.avante").mcp_tool(),
					}
				end,
				disabled_tools = {
					-- brave search mcp server
					"web_search",

					-- fetch mcp server
					"fetch",

					-- git mcp server
					"git_diff",
					"git_commit",
				},
				behaviour = {
					enable_claude_text_editor_tool_mode = true,
					-- WARNING: auto suggestions is experimental stage
					--          `copilot` provider is expensive and dangerous
					--          https://github.com/yetone/avante.nvim/issues/1048
					auto_suggestions = false,
				},
			}
		end,
		config = function(_, opts)
			require("avante").setup(opts)
		end,
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						verbose = false,
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				-- NOTE: render-markdown.nvim lazy load automatically
				-- https://github.com/yetone/avante.nvim/issues/1450
				lazy = false,
				init = function()
					-- HACK: set empty string into breakat to disable linebreak
					--       linebreak does not work in japanese, but render-markdown.nvim enable linebreak always
					vim.opt.breakat = ""
				end,
				opts = {
					file_types = { "Avante" },
					render_modes = true,
					heading = {
						width = "block",
						icons = {},
					},
					code = {
						width = "block",
						min_width = 45,
						border = "thin",
					},
				},
			},
			{
				"ravitemer/mcphub.nvim",
				build = "bundled_build.lua",
				cmd = "MCPHub",
				keys = {
					{
						"<Space>pm",
						vim.cmd.MCPHub,
						silent = true,
						desc = "Open UI for MCP servers",
					},
				},
				opts = {
					auto_approve = false,
					use_bundled_binary = true,
					extensions = {
						avante = {
							make_slash_commands = true,
						},
					},
					ui = {
						window = {
							border = "single",
						},
					},
				},
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
		},
	},
}
