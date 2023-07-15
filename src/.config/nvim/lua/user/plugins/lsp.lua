return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("neodev").setup({})

			local lspconfig = require("lspconfig")

			vim.diagnostic.config({
				virtual_text = false,
			})

			vim.keymap.set("n", "<space>li", vim.cmd.LspInfo, { desc = "Show LSP information" })
			vim.keymap.set("n", "<space>ll", vim.cmd.LspLog, { desc = "Show LSP log" })
			vim.keymap.set("n", "<space>l<C-i>", vim.cmd.NullLsInfo, { desc = "Show null-ls information" })
			vim.keymap.set("n", "<space>l<C-l>", vim.cmd.NullLsLog, { desc = "Show null-ls log" })

			local augroup = vim.api.nvim_create_augroup("lsp_document_formatting", {})
			local on_attach = function(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				local bufopts = { silent = true, buffer = bufnr }
				vim.keymap.set("n", "gh", function()
					require("lspsaga.finder"):lsp_finder()
				end, bufopts)
				vim.keymap.set("n", "gd", function()
					require("lspsaga.definition"):peek_definition()
				end, bufopts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "g<C-i>", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set(
					"n",
					"gl",
					[[:lua vim.diagnostic.open_float()<cr><C-w><C-w>]],
					{ desc = "Show diagnostics in float window", silent = true }
				)
				vim.keymap.set("n", "gO", function()
					require("symbols-outline").open_outline()
				end, {
					silent = true,
					desc = "Toggle symbols outline",
				})
				vim.keymap.set("n", "g<C-t>", function()
					require("trouble").open()
				end, {
					silent = true,
					desc = "Toggle trouble (diagnostics) panel",
				})
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev({ float = false })
				end, bufopts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_next({ float = false })
				end, bufopts)
				vim.keymap.set("n", "[<C-d>", function()
					vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
				end, bufopts)
				vim.keymap.set("n", "]<C-d>", function()
					vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
				end, bufopts)
				vim.keymap.set("n", "K", function()
					local winid = require("ufo").peekFoldedLinesUnderCursor()
					if not winid then
						require("lspsaga.hover"):render_hover_doc()
					end
				end, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "g<C-r>", function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end, { expr = true })
				vim.keymap.set({ "n", "v" }, "gA", require("code_action_menu").open_code_action_menu, bufopts)
				vim.keymap.set("n", "<space>lb", require("nvim-navbuddy").open, bufopts)

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end

				if client.name == "lua_ls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				if client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_set_hl(0, "LspReferenceRead", {
						bg = "#45403d",
						bold = true,
					})
					vim.api.nvim_set_hl(0, "LspReferenceText", {
						bg = "#45403d",
						bold = true,
					})
					vim.api.nvim_set_hl(0, "LspReferenceWrite", {
						bg = "#45403d",
						bold = true,
					})
					local auname = "lsp_document_highlight"
					vim.api.nvim_create_augroup(auname, {})
					vim.api.nvim_clear_autocmds({ group = auname, buffer = bufnr })
					vim.api.nvim_create_autocmd("CursorHold", {
						group = auname,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.document_highlight()
						end,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						group = auname,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.clear_references()
						end,
					})
				end

				if client.server_capabilities.documentSymbolProvider then
					local navic = require("nvim-navic")
					local navbuddy = require("nvim-navbuddy")
					navic.attach(client, bufnr)
					navbuddy.attach(client, bufnr)
				end
			end

			local servers = {
				"bashls",
				"cssls",
				"dockerls",
				"emmet_ls",
				"graphql",
				"marksman",
				"taplo",
				"terraformls",
				"tsserver",
				"yamlls",
			}

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.go" },
				callback = function()
					vim.lsp.buf.formatting_sync(nil, 3000)
				end,
			})

			require("lspconfig").jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.go" },
				callback = function()
					local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
					params.context = { only = { "source.organizeImports" } }

					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					for _, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
							else
								vim.lsp.buf.execute_command(r.command)
							end
						end
					end
				end,
			})

			require("lspconfig").gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})

			require("lspconfig").denols.setup({
				-- NOTE: Ignore .git to avoid conflict between tsserver and denols
				root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
				init_options = {
					enable = true,
					lint = false,
					unstable = false,
					importMap = "./import_map.json",
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})

			require("lspconfig").lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				preview = {
					win_config = {
						border = { "", "─", "", "", "", "─", "", "" },
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
					},
				},
				fold_virt_text_handler = handler,
			})

			local bufnr = vim.api.nvim_get_current_buf()
			require("ufo").setFoldVirtTextHandler(bufnr, handler)
			require("lsp_signature").setup({
				hint_enable = false,
				handler_opts = {
					border = "single",
				},
			})
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "weilbith/nvim-code-action-menu" },
			{ "b0o/SchemaStore.nvim" },
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
			},
			{
				"smjonas/inc-rename.nvim",
				config = function()
					require("inc_rename").setup({})
				end,
			},
			{ "folke/neodev.nvim" },
			{
				"kevinhwang91/nvim-ufo",
				config = function()
					vim.o.foldcolumn = "0"
					vim.o.foldlevel = 99
					vim.o.foldlevelstart = 99
					vim.o.foldenable = true
				end,
				dependencies = "kevinhwang91/promise-async",
			},
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						segments = {
							{
								sign = { name = { "Diagnostic" }, colwidth = 1 },
								click = "v:lua.ScSa",
							},
							{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
							{
								sign = { name = { ".*" }, colwidth = 1 },
								click = "v:lua.ScSa",
							},
						},
					})
				end,
			},
			{
				"glepnir/lspsaga.nvim",
				event = "BufRead",
				config = function()
					require("lspsaga").setup({
						request_timeout = 5000,
						lightbulb = {
							virtual_text = false,
						},
						symbol_in_winbar = {
							enable = false,
						},
						ui = {
							title = false,
							border = "single",
							code_action = "",
						},
					})
				end,
			},
			{
				"simrat39/symbols-outline.nvim",
				config = function()
					require("symbols-outline").setup({
						symbols = {
							File = { hl = "@text.uri" },
							Module = { hl = "@namespace" },
							Namespace = { hl = "@namespace" },
							Package = { hl = "@namespace" },
							Class = { hl = "@type" },
							Method = { hl = "@method" },
							Property = { hl = "@method" },
							Field = { hl = "@field" },
							Constructor = { hl = "@constructor" },
							Enum = { hl = "@type" },
							Interface = { hl = "@type" },
							Function = { hl = "@function" },
							Variable = { hl = "@constant" },
							Constant = { hl = "@constant" },
							String = { hl = "@string" },
							Number = { hl = "@number" },
							Boolean = { hl = "@boolean" },
							Array = { hl = "@constant" },
							Object = { hl = "@type" },
							Key = { hl = "@type" },
							Null = { hl = "@type" },
							EnumMember = { hl = "@field" },
							Struct = { hl = "@type" },
							Event = { hl = "@type" },
							Operator = { hl = "@operator" },
							TypeParameter = { hl = "@parameter" },
						},
					})
				end,
			},
			{
				"folke/trouble.nvim",
				config = function()
					require("trouble").setup({})
				end,
			},
		},
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "append",
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"bash-language-server",
					"css-lsp",
					"dockerfile-language-server",
					"emmet-ls",
					"graphql-language-service-cli",
					"marksman",
					"taplo",
					"terraform-ls",
					"tflint",
					"typescript-language-server",
					"yaml-language-server",
					"gopls",
					"lua-language-server",
				},
			})
			vim.keymap.set("n", "<Space>p<C-p>", vim.cmd.Mason, {
				silent = true,
				desc = "Show package manager for LSP",
			})
			do
				local auname = "mason"
				vim.api.nvim_create_augroup(auname, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = auname,
					pattern = "mason",
					callback = function()
						vim.opt_local.winblend = 0
					end,
				})
			end
		end,
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("null_ls_lsp_document_formatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.actionlint,
					null_ls.builtins.diagnostics.jsonlint,
					null_ls.builtins.diagnostics.editorconfig_checker,
					null_ls.builtins.diagnostics.opacheck.with({
						args = { "check", "-f", "json", "--strict", "$DIRNAME" },
					}),
					null_ls.builtins.diagnostics.semgrep.with({
						args = { "-q", "--json", "--config", "auto", "$FILENAME" },
					}),
					null_ls.builtins.formatting.sql_formatter.with({
						args = { "-c", vim.fn.expand("~/.config/sql-formatter/config.json") },
						filetypes = { "sql", "mysql" },
					}),
					null_ls.builtins.formatting.just,
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.dprint.with({
						args = {
							"fmt",
							"--config",
							vim.fn.expand("~/.config/dprint/dprint.json"),
							"--stdin",
							"$FILENAME",
						},
						filetypes = { "markdown", "json" },
					}),
					null_ls.builtins.formatting.markdownlint,
					null_ls.builtins.diagnostics.markdownlint,
					null_ls.builtins.formatting.shellharden.with({
						filetypes = { "sh", "direnv" },
					}),
					null_ls.builtins.formatting.shfmt.with({
						filetypes = { "sh", "direnv" },
					}),
					null_ls.builtins.diagnostics.shellcheck,
					null_ls.builtins.formatting.prettier.with({
						filetypes = { "yaml", "css" },
					}),
					null_ls.builtins.diagnostics.stylelint.with({
						args = {
							"--formatter",
							"json",
							"--stdin-filename",
							"$FILENAME",
							"--config",
							vim.fn.expand("~/.stylelintrc.yaml"),
						},
					}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.diagnostics.selene,
					null_ls.builtins.diagnostics.codespell,
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.formatting.eslint,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function()
			require("fidget").setup({
				text = {
					spinner = "dots",
					done = "✓",
				},
			})
		end,
	},
}
