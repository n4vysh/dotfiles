return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
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
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}, {
					{ name = "path" },
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
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "onsails/lspkind.nvim" },
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()

					vim.keymap.set("i", "<Tab>", function()
						if require("luasnip").expand_or_jumpable() then
							return "<Plug>luasnip-expand-or-jump"
						else
							return "<Tab>"
						end
					end, {
						silent = true,
						remap = true,
						expr = true,
						desc = "Expand a snippet or jump to another node",
					})

					vim.keymap.set("i", "<S-Tab>", function()
						require("luasnip").jump(-1)
					end, {
						silent = true,
						desc = "Jump backward to another node",
					})

					vim.keymap.set("s", "<Tab>", function()
						require("luasnip").jump(1)
					end, {
						silent = true,
						desc = "Jump forward to another node",
					})

					vim.keymap.set("s", "<S-Tab>", function()
						require("luasnip").jump(-1)
					end, {
						silent = true,
						desc = "Jump backward to another node",
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
