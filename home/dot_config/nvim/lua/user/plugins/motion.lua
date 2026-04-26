return {
	{
		"rhysd/clever-f.vim",
		init = function()
			vim.g.clever_f_across_no_line = 1
			vim.g.clever_f_not_overwrites_standard_mappings = 1
		end,
		keys = {
			{
				"f",
				"<Plug>(clever-f-f)",
				mode = { "n", "x", "o" },
				remap = true,
			},
			{
				"F",
				"<Plug>(clever-f-F)",
				mode = { "n", "x", "o" },
				remap = true,
			},
			{
				"t",
				"<Plug>(clever-f-t)",
				mode = { "n", "x", "o" },
				remap = true,
			},
			{
				"T",
				"<Plug>(clever-f-T)",
				mode = { "n", "x", "o" },
				remap = true,
			},
			{
				";",
				"<Plug>(clever-f-repeat-forward)",
				mode = { "n", "x", "s", "o" },
				remap = true,
			},
			{
				",",
				"<Plug>(clever-f-repeat-back)",
				mode = { "n", "x", "s", "o" },
				remap = true,
			},
			{
				"<Esc>",
				"<Plug>(clever-f-reset)",
				mode = { "n" },
				remap = false,
			},
		},
	},
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		keys = {
			{ "s", "<Plug>(leap)", mode = { "n", "x", "o" } },
			{ "S", "<Plug>(leap-from-window)" },
		},
	},
}
