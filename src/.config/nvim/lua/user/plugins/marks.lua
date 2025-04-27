return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		keys = {
			{
				"<Space>ma",
				function()
					harpoon:list():add()
				end,
				silent = true,
				desc = "Add file to mark per project",
			},
			{
				"<Space>ml",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				silent = true,
				desc = "List marks of project",
			},
			{
				"<space>mm",
				function()
					local conf = require("telescope.config").values
					local function toggle_telescope(harpoon_files)
						local file_paths = {}
						for _, item in ipairs(harpoon_files.items) do
							table.insert(file_paths, item.value)
						end

						require("telescope.pickers")
							.new({}, {
								prompt_title = "Harpoon",
								finder = require("telescope.finders").new_table({
									results = file_paths,
								}),
								previewer = conf.file_previewer({}),
								sorter = conf.generic_sorter({}),
							})
							:find()
					end
					toggle_telescope(harpoon:list())
				end,
				silent = true,
				desc = "Search for marks with fuzzy finder",
			},
		},
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
		config = function(_, opts)
			-- NOTE: use :setup in lazy.nvim
			-- https://github.com/ThePrimeagen/harpoon/issues/362#issuecomment-1859234905
			-- selene: allow(unscoped_variables, unused_variable)
			harpoon = require("harpoon"):setup(opts)
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
