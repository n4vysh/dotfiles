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
		config = function()
			require("copilot_cmp").setup()
		end,
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
		},
		opts = {
			hints = { enabled = false },
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub:get_active_servers_prompt()
			end,
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
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
				opts = {
					file_types = { "Avante" },
				},
				ft = { "Avante" },
			},
			{
				"ravitemer/mcphub.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				cmd = "MCPHub",
				opts = {
					auto_approve = false,
				},
			},
		},
	},
}
