return {
	{
		"ggandor/leap.nvim",
		-- NOTE: leap.nvim lazy load automatically
		-- https://github.com/ggandor/leap.nvim#lazy-loading
		lazy = false,
		config = function()
			require("leap").add_default_mappings()
		end,
	},
}
