return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local compare = cmp.config.compare

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				sorting = {
					comparators = {
						require("copilot_cmp.comparators").prioritize,
						compare.offset,
						compare.exact,
						-- compare.scopes,
						-- NOTE: disable sorting of nvim-cmp
						-- https://github.com/hrsh7th/nvim-cmp/issues/766#issuecomment-1024909862
						compare.sort_text,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.kind,
						compare.length,
						compare.order,
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 5 },
					{ name = "luasnip", priority = 4 },
				}, {
					{ name = "buffer", priority = 3 },
				}, {
					{ name = "path", priority = 2 },
				}, {
					{ name = "copilot", priority = 1 },
				}),
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			local lspkind = require("lspkind")
			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
					}),
				},
			})
		end,
		dependencies = {
			{ "zbirenbaum/copilot-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{
				"onsails/lspkind.nvim",
				config = function()
					local lspkind = require("lspkind")
					lspkind.init({
						symbol_map = {
							Copilot = "",
						},
					})

					vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
				end,
				dependencies = {
					{ "zbirenbaum/copilot-cmp" },
				},
			},
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				keys = {
					{
						"<C-k>",
						function()
							if require("luasnip").expandable() then
								require("luasnip").expand()
							elseif require("luasnip").jumpable(1) then
								require("luasnip").jump(1)
							end
						end,
						mode = "i",
						silent = true,
						desc = "Expand a snippet or jump to another node",
					},
					{
						"<C-l>",
						function()
							require("luasnip").jump(-1)
						end,
						mode = "i",
						silent = true,
						desc = "Jump backward to another node",
					},
					{
						"<C-k>",
						function()
							require("luasnip").jump(1)
						end,
						mode = "s",
						silent = true,
						desc = "Jump forward to another node",
					},
					{
						"<C-l>",
						function()
							require("luasnip").jump(-1)
						end,
						mode = "s",
						silent = true,
						desc = "Jump backward to another node",
					},
				},
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					local ls = require("luasnip")
					local s, sn = ls.snippet, ls.snippet_node
					local i, d = ls.insert_node, ls.dynamic_node

					ls.add_snippets("lua", {
						ls.parser.parse_snippet({ trig = "fua", desc = "Anonymous function" }, "function()\n\t${0:-- code}\nend"),
					}, {
						key = "lua",
					})

					local function uuid()
						local id, _ = vim.fn.system("uuidgen"):gsub("\n", "")
						return id
					end

					ls.add_snippets("global", {
						s({
							trig = "uuid",
							name = "UUID",
							dscr = "Generate a unique UUID",
						}, {
							d(1, function()
								return sn(nil, i(1, uuid()))
							end),
						}),
					})
				end,
				dependencies = {
					{ "rafamadriz/friendly-snippets" },
				},
			},
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},
}
