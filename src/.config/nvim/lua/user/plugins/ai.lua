return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
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
		"jackMort/ChatGPT.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{ "<space>ai", "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain code with ChatGPT" },
		},
		opts = {
			api_key_cmd = "gopass show -o n4vysh/openai/chatgpt.nvim",
			chat = {
				sessions_window = {
					border = {
						style = "single",
					},
				},
			},
			popup_window = {
				border = {
					style = "single",
				},
			},
			system_window = {
				border = {
					style = "single",
				},
			},
			popup_input = {
				border = {
					style = "single",
				},
			},
			settings_window = {
				border = {
					style = "single",
				},
			},
			help_window = {
				border = {
					style = "single",
				},
			},
			actions_paths = {
				vim.fn.stdpath("config") .. "/misc/chatgpt-actions.json",
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
