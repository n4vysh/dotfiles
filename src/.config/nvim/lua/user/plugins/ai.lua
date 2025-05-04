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
			local provider = "claude"

			if vim.fn.exists("$BEDROCK_KEYS") == 1 then
				provider = "bedrock-claude-3.7-sonnet"
			end

			return {
				provider = provider,
				hints = { enabled = false },
				file_selector = {
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
					return hub:get_active_servers_prompt()
				end,
				custom_tools = function()
					return {
						require("mcphub.extensions.avante").mcp_tool(),
					}
				end,
				disabled_tools = {
					"list_files",
					"search_files",
					"read_file",
					"create_file",
					"rename_file",
					"delete_file",
					"create_dir",
					"rename_dir",
					"delete_dir",
					"bash",
				},
				behaviour = {
					enable_claude_text_editor_tool_mode = true,
				},
			}
		end,
		config = function(_, opts)
			require("avante").setup(opts)

			require("avante.config").override({
				system_prompt = "Respond in japanese",
			})
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
						border = "thick",
					},
				},
				ft = { "Avante" },
			},
			{
				"ravitemer/mcphub.nvim",
				build = "bundled_build.lua",
				cmd = "MCPHub",
				opts = {
					auto_approve = false,
					use_bundled_binary = true,
				},
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
		},
	},
}
