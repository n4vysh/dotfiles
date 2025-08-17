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
						-- NOTE: create new `[No Name]` buffer when dashboard
						if vim.bo.filetype == "dashboard" then
							vim.cmd.enew()
						end

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
						-- NOTE: create new `[No Name]` buffer when dashboard
						if vim.bo.filetype == "dashboard" then
							vim.cmd.enew()
						end

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
				-- WARNING: always use `claude` provider
				--          `copilot` provider is expensive and dangerous
				--          https://github.com/yetone/avante.nvim/issues/1048
				auto_suggestions_provider = "claude",
				providers = {
					copilot = {
						model = "claude-sonnet-4",
					},
					openai = {
						endpoint = "http://127.0.0.1:4000/v1",
						model = "us.anthropic.claude-sonnet-4-20250514-v1:0",
						-- NOTE: use the same max_tokens value as litellm's default
						-- https://github.com/BerriAI/litellm/blob/05e0a6d8d5a52e5cacebebe8e9ba37b3a9c800ef/litellm/constants.py
						extra_request_body = {
							max_tokens = 16384,
						},
					},
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
			{
				"ravitemer/mcphub.nvim",
				build = "bundled_build.lua",
				cmd = "MCPHub",
				keys = {
					{
						"<Space>pm",
						function()
							-- NOTE: create new `[No Name]` buffer when dashboard
							if vim.bo.filetype == "dashboard" then
								vim.cmd.enew()
							end

							vim.cmd.MCPHub()
						end,
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
