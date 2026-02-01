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
		keys = function(_, keys)
			---@type avante.Config
			local opts = require("lazy.core.plugin").values(
				require("lazy.core.config").spec.plugins["avante.nvim"],
				"opts",
				false
			)

			local mappings = {
				{
					opts.mappings.ask,
					function()
						require("avante.api").ask()
					end,
					desc = "Show sidebar for AI",
					mode = { "n" },
				},
				{
					opts.mappings.ask,
					function()
						require("avante.api").ask()
					end,
					desc = "Show sidebar for AI",
					mode = { "v" },
				},
				{
					opts.mappings.new_chat,
					function()
						require("avante.api").ask({ new_chat = true })
					end,
					desc = "Start new chat session for AI",
					mode = { "n" },
				},
				{
					opts.mappings.new_chat,
					function()
						require("avante.api").ask({ new_chat = true })
					end,
					desc = "Start new chat session for AI",
					mode = { "v" },
				},
				{
					opts.mappings.select_history,
					function()
						require("avante.api").select_history()
					end,
					desc = "Opens chat sessions for AI",
					mode = { "n" },
				},
				{
					opts.mappings.edit,
					function()
						require("avante.api").edit()
					end,
					desc = "Edit selected blocks for AI",
					mode = { "v" },
				},
				{
					opts.mappings.stop,
					function()
						require("avante.api").stop()
					end,
					desc = "Stop current requests for AI",
					mode = { "n" },
				},
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = function()
			-- NOTE: use copilot as default provider to avoid Claude's API rate limits and costs
			local provider = "copilot"

			-- NOTE: comment in to use bedrock with litellm
			-- provider = "openai"

			return {
				provider = provider,
				-- WARNING: do not use `copilot` provider
				--          `copilot` provider is expensive and dangerous
				--          https://github.com/yetone/avante.nvim/issues/1048
				auto_suggestions_provider = nil,
				providers = {
					copilot = {
						model = "claude-sonnet-4.5",
					},
					openai = {
						endpoint = "http://127.0.0.1:4000/v1",
						model = "bedrock/converse/us.anthropic.claude-sonnet-4-5-20250929-v1:0",
						-- NOTE: use the same max_tokens value as litellm's default
						-- https://github.com/BerriAI/litellm/blob/05e0a6d8d5a52e5cacebebe8e9ba37b3a9c800ef/litellm/constants.py
						extra_request_body = {
							max_tokens = 16384,
						},
					},
				},
				selection = {
					hint_display = "none",
				},
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
					return [[
					- Respond in japanese.
					- When making code comments, create it in english.
					- When making a commit, create a message in english using conventional commit format and gitmoji.

				]]
				end,
				disabled_tools = {
					"web_search",
				},
				behaviour = {
					enable_claude_text_editor_tool_mode = true,
					-- WARNING: auto suggestions is experimental stage
					--          `copilot` provider is expensive and dangerous
					--          https://github.com/yetone/avante.nvim/issues/1048
					auto_suggestions = false,
				},
				mappings = {
					ask = "<space>aa",
					new_chat = "<space>an",
					select_history = "<space>ah",
					edit = "<space>ae",
					stop = "<space>as",
				},
				input = {
					provider = "snacks",
					provider_opts = {
						title = "Avante Input",
						icon = " ",
					},
				},
			}
		end,
		config = function(_, opts)
			require("avante").setup(opts)
		end,
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			"nvim-treesitter/nvim-treesitter",
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
		},
	},
}
