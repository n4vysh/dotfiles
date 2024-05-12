return {
	{
		"williamboman/mason.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{
				"<Space>pp",
				function()
					vim.ui.select({ "plugins", "external tool" }, {
						prompt = "package manager information",
					}, function(choice)
						if choice == nil then
							do
							end
						elseif choice == "plugins" then
							require("lazy").home()
						else
							vim.cmd.Mason()
						end
					end)
				end,
				{
					silent = true,
					desc = "Show package manager information",
				},
			},
		},
		config = function()
			require("mason").setup({
				PATH = "append",
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"bash-language-server",
					"buf-language-server",
					"css-lsp",
					"dockerfile-language-server",
					"docker-compose-language-service",
					"emmet-ls",
					"eslint-lsp",
					"golangci-lint-langserver",
					"graphql-language-service-cli",
					"helm-ls",
					"json-lsp",
					"marksman",
					"tailwindcss-language-server",
					"taplo",
					"terraform-ls",
					"typescript-language-server",
					"typos-lsp",
					"yaml-language-server",
					"gopls",
					"lua-language-server",
				},
			})
			do
				local augroup = "mason"
				vim.api.nvim_create_augroup(augroup, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = augroup,
					pattern = "mason",
					callback = function()
						vim.opt_local.winblend = 0
					end,
				})
			end
		end,
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"stevearc/dressing.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{
				"<space>li",
				function()
					vim.ui.select({ "normal lang server", "null lang server" }, {
						prompt = "lang server information",
					}, function(choice)
						if choice == nil then
							do
							end
						elseif choice == "normal lang server" then
							vim.cmd.LspInfo()
						else
							vim.cmd.NullLsInfo()
						end
					end)
				end,
				{ desc = "Show lang server information" },
			},
			{
				"<space>ll",
				function()
					vim.ui.select({ "normal lang server", "null lang server" }, {
						prompt = "lang server log",
					}, function(choice)
						if choice == nil then
							do
							end
						elseif choice == "normal lang server" then
							vim.cmd.LspLog()
						else
							vim.cmd.NullLsLog()
						end
					end)
				end,
				{ desc = "Show lang server log" },
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local buf = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					vim.diagnostic.config({
						virtual_text = false,
					})

					vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { silent = true, buffer = buf }
					vim.keymap.set("n", "gp", function()
						require("lspsaga.finder"):new({})
					end, vim.tbl_extend("force", opts, { desc = "Goto preview of references and implementation" }))
					vim.keymap.set("n", "gd", function()
						require("lspsaga.definition"):init(1, 1)
					end, vim.tbl_extend("force", opts, { desc = "Goto preview of definition" }))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set(
						"n",
						"<C-w>d",
						[[:lua vim.diagnostic.open_float()<cr><C-w><C-w>]],
						vim.tbl_extend("force", opts, { desc = "Show diagnostics in float window" })
					)
					vim.keymap.set("n", "go", function()
						vim.cmd([[normal m']])

						require("lspsaga.symbol.outline"):outline()
					end, vim.tbl_extend("force", opts, { desc = "Toggle symbols outline" }))
					vim.keymap.set("n", "g<C-t>", function()
						-- HACK:Use jump list
						-- https://github.com/folke/trouble.nvim/issues/235
						vim.cmd([[normal m']])

						require("trouble").open()
					end, vim.tbl_extend("force", opts, { desc = "Toggle trouble (diagnostics) panel" }))
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_prev({ float = false })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_next({ float = false })
					end, opts)
					vim.keymap.set("n", "K", function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							require("lspsaga.hover"):render_hover_doc({})
						end
					end, opts)
					vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "crn", function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end, { expr = true })
					vim.keymap.set("n", "crr", require("actions-preview").code_actions, opts)
					vim.keymap.set("v", "<C-r>r", require("actions-preview").code_actions, opts)
					vim.keymap.set("v", "<C-r><C-r>", require("actions-preview").code_actions, opts)

					if client.supports_method("textDocument/formatting") then
						local augroup = vim.api.nvim_create_augroup("lsp_document_formatting_" .. buf, {})

						vim.api.nvim_clear_autocmds({ group = augroup, buffer = buf })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = buf,
							callback = function()
								vim.lsp.buf.format({ buf = buf })
							end,
						})
					end

					if client.name == "lua_ls" or client.name == "terraformls" then
						client.server_capabilities.signatureHelpProvider = false
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
						local augroup = "lsp_document_highlight_" .. buf
						vim.api.nvim_create_augroup(augroup, {})
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = buf })
						vim.api.nvim_create_autocmd("CursorHold", {
							group = augroup,
							buffer = buf,
							callback = function()
								vim.lsp.buf.document_highlight()
							end,
						})
						vim.api.nvim_create_autocmd("CursorMoved", {
							group = augroup,
							buffer = buf,
							callback = function()
								vim.lsp.buf.clear_references()
							end,
						})
					end

					if client.server_capabilities.documentSymbolProvider then
						local navic = require("nvim-navic")
						navic.attach(client, buf)
					end
				end,
			})

			local servers = {
				"bashls", -- NOTE: require shellcheck for linting from bashls
				"bufls",
				"cssls",
				"dockerls",
				"docker_compose_language_service",
				"emmet_ls",
				"golangci_lint_ls",
				"graphql",
				"helm_ls",
				"marksman",
				"tailwindcss",
				"taplo",
				"terraformls",
				"tflint",
				"tilt_ls",
				"tsserver",
			}

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					capabilities = capabilities,
				})
			end

			lspconfig.typos_lsp.setup({
				init_options = {
					diagnosticSeverity = "Hint",
				},
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				on_attach = function(_, buf)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = buf,
						command = "EslintFixAll",
					})
				end,
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

			lspconfig.jsonls.setup({
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
				capabilities = capabilities,
			})

			lspconfig.yamlls.setup({
				settings = {
					yaml = {
						schemaStore = {
							-- NOTE: disable built-in schemaStore support and use SchemaStore.nvim
							enable = false,
							-- NOTE: Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
				capabilities = capabilities,
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

			lspconfig.gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
						analyses = {
							fillstruct = true,
						},
					},
				},
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
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
						diagnostics = {
							disable = { "lowercase-global" },
						},
					},
				},
			})

			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.actionlint,
					null_ls.builtins.diagnostics.buf,
					null_ls.builtins.formatting.buf,
					null_ls.builtins.diagnostics.editorconfig_checker,
					null_ls.builtins.formatting.rego,
					null_ls.builtins.diagnostics.opacheck,
					null_ls.builtins.diagnostics.semgrep.with({
						args = { "-q", "--json", "--config", "auto", "$FILENAME" },
					}),
					null_ls.builtins.formatting.sql_formatter.with({
						args = { "-c", vim.fn.expand("~/.config/sql-formatter/config.json") },
						filetypes = { "sql", "mysql" },
					}),
					null_ls.builtins.formatting.just,
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.diagnostics.markdownlint_cli2,
					null_ls.builtins.formatting.shellharden.with({
						filetypes = { "sh", "direnv" },
					}),
					null_ls.builtins.formatting.shfmt.with({
						filetypes = { "sh", "direnv" },
					}),
					null_ls.builtins.formatting.prettier.with({
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"json",
							"jsonc",
							"markdown",
							"markdown.mdx",
							"graphql",
						},
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
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.formatting.yamlfmt,
					null_ls.builtins.diagnostics.zsh,
					null_ls.builtins.diagnostics.todo_comments,
					null_ls.builtins.diagnostics.fish,
					-- NOTE: terraform-ls is slow
					null_ls.builtins.formatting.terraform_fmt,
				},
			})
		end,
		dependencies = {
			{ "stevearc/dressing.nvim" },
			{ "williamboman/mason.nvim" },
			{
				"nvimtools/none-ls.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{ "b0o/SchemaStore.nvim" },
			{ "folke/neodev.nvim", opts = {} },
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			local buf = vim.api.nvim_get_current_buf()
			require("lsp_signature").on_attach({
				hint_enable = false,
				handler_opts = {
					border = "single",
				},
			}, buf)
		end,
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		event = "LspAttach",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local hl = require("actions-preview.highlight")
			require("actions-preview").setup({
				highlight_command = {
					hl.delta("delta"),
				},
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		event = "LspAttach",
		opts = {},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		event = "LspAttach",
		config = function()
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
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

			local providers = {
				-- NOTE: `nil` will use default value {'lsp', 'indent'}
				-- https://github.com/kevinhwang91/nvim-ufo/issues/6#issuecomment-1172346709
				-- HACK: use tree-sitter-markdown instead of marksman
				--       marksman not support folding
				markdown = { "treesitter", "indent" },
			}
			require("ufo").setup({
				provider_selector = function(_, filetype, _)
					return providers[filetype]
				end,
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

			local buf = vim.api.nvim_get_current_buf()
			require("ufo").setFoldVirtTextHandler(buf, handler)
		end,
		dependencies = {
			"neovim/nvim-lspconfig",
			"kevinhwang91/promise-async",
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		opts = {
			request_timeout = 5000,
			lightbulb = {
				virtual_text = false,
			},
			outline = {
				close_after_jump = true,
			},
			symbol_in_winbar = {
				enable = false,
			},
			ui = {
				border = "single",
				code_action = "",
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/trouble.nvim",
		event = "LspAttach",
		opts = {
			action_keys = {
				-- NOTE: jump action can't work jump back,
				--       so use always jump_close action
				jump = {},
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"SmiteshP/nvim-navic",
		event = "LspAttach",
		init = function()
			vim.o.winbar = " "
		end,
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				highlight = true,
			})
			vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
		end,
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
}
