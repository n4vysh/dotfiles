return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
		keys = {
			{
				"<Space>ft",
				function()
					if vim.fn.expand("%") == "" then
						vim.cmd.NvimTreeToggle()
					else
						vim.cmd.NvimTreeFindFile()
					end
				end,
				desc = "Toggle file tree",
			},
		},
		opts = {
			hijack_cursor = true,
			hijack_netrw = false,
			view = {
				width = {
					max = -1,
				},
				float = {
					enable = false,
				},
			},
			sort = {
				sorter = "case_sensitive",
			},
			filters = {
				git_ignored = false,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					git_placement = "right_align",
					modified_placement = "right_align",
					diagnostics_placement = "right_align",
					bookmarks_placement = "right_align",
					padding = " ",
					show = {
						file = true,
						folder = true,
						diagnostics = true,
						bookmarks = true,
						git = true,
						modified = true,
					},
				},
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- custom mappings
				vim.keymap.del("n", "g?", opts("Help"))
				vim.keymap.set("n", "<C-_>", api.tree.toggle_help, opts("Help"))
				vim.keymap.del("n", "ge", opts("Copy Basename"))
				vim.keymap.del("n", "gy", opts("Copy Absolute Path"))
				vim.keymap.del("n", "Y", opts("Copy Relative Path"))
				vim.keymap.del("n", "y", opts("Copy Name"))
				vim.keymap.set(
					"n",
					"yb",
					api.fs.copy.basename,
					opts("Copy Basename")
				)
				vim.keymap.set(
					"n",
					"yf",
					api.fs.copy.absolute_path,
					opts("Copy Absolute Path")
				)
				vim.keymap.set(
					"n",
					"yr",
					api.fs.copy.relative_path,
					opts("Copy Relative Path")
				)
				vim.keymap.set(
					"n",
					"yn",
					api.fs.copy.filename,
					opts("Copy Name")
				)
				vim.keymap.del("n", "e", opts("Rename: Basename"))

				local function edit_and_close(node)
					api.node.open.edit(node, { close_tree = true })
					api.tree.close()
				end

				vim.keymap.set("n", "e", edit_and_close, opts("Edit"))
			end,
		},
		dependencies = {
			"stevearc/dressing.nvim",
		},
	},
}
