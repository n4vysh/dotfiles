return {
	{
		"williamboman/mason.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		cmd = { "Mason" },
		keys = {
			{
				"<Space>pt",
				function()
					-- NOTE: create new `[No Name]` buffer when dashboard
					if vim.bo.filetype == "dashboard" then
						vim.cmd.enew()
					end

					vim.cmd.Mason()
				end,
				silent = true,
				desc = "Open UI for tools",
			},
		},
		opts = {
			PATH = "append",
			ui = {
				border = "single",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		keys = {
			{
				"<space>li",
				function()
					vim.ui.select(
						{ "normal lang server", "null lang server" },
						{
							prompt = "lang server information",
						},
						function(choice)
							if choice == nil then
								do
								end
							elseif choice == "normal lang server" then
								vim.cmd.LspInfo()
							else
								vim.cmd.NullLsInfo()
							end
						end
					)
				end,
				desc = "Show lang server information",
			},
			{
				"<space>ll",
				function()
					vim.ui.select(
						{ "normal lang server", "null lang server" },
						{
							prompt = "lang server log",
						},
						function(choice)
							if choice == nil then
								do
								end
							elseif choice == "normal lang server" then
								vim.cmd.LspLog()
							else
								vim.cmd.NullLsLog()
							end
						end
					)
				end,
				desc = "Show lang server log",
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local buf = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					vim.diagnostic.config({
						virtual_text = false,
						float = {
							border = "single",
						},
					})

					vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { silent = true, buffer = buf }
					vim.keymap.set(
						"n",
						"gp",
						function()
							require("lspsaga.finder"):new({})
						end,
						vim.tbl_extend("force", opts, {
							desc = "Goto preview of references and implementation",
						})
					)
					vim.keymap.set(
						"n",
						"gd",
						function()
							require("lspsaga.definition"):init(1, 1)
						end,
						vim.tbl_extend("force", opts, {
							desc = "Goto preview of definition",
						})
					)
					vim.keymap.set(
						"n",
						"gy",
						function()
							require("lspsaga.definition"):init(2, 1)
						end,
						vim.tbl_extend("force", opts, {
							desc = "Goto preview of t[y]pe definition",
						})
					)
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, {
							desc = "Goto preview of declaration",
						})
					)
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, {
							desc = "Goto preview of implementation",
						})
					)
					vim.keymap.set(
						"n",
						"<C-w>d",
						function()
							local _, win = vim.diagnostic.open_float({
								format = function(diagnostic)
									local source = diagnostic.source
										or "unknown"
									return string.format(
										"%s [%s]",
										diagnostic.message,
										source
									)
								end,
							})
							if win then
								vim.api.nvim_set_current_win(win)
							end
						end,
						vim.tbl_extend("force", opts, {
							desc = "Show diagnostics in float window",
						})
					)
					vim.keymap.set(
						"n",
						"go",
						function()
							vim.cmd([[normal m']])

							require("lspsaga.symbol.outline"):outline()
						end,
						vim.tbl_extend("force", opts, {
							desc = "Toggle symbols outline",
						})
					)
					vim.keymap.set(
						"n",
						"g<C-t>",
						function()
							require("trouble").open({
								mode = "diagnostics",
								focus = true,
							})
						end,
						vim.tbl_extend("force", opts, {
							desc = "Toggle trouble (diagnostics) panel",
						})
					)
					vim.keymap.set(
						"n",
						"K",
						function()
							local winid =
								require("ufo").peekFoldedLinesUnderCursor()
							if not winid then
								require("lspsaga.hover"):render_hover_doc({})
							end
						end,
						vim.tbl_extend("force", opts, {
							desc = [[Show LSP "hover" feature]],
						})
					)
					vim.keymap.set(
						"i",
						"<C-s>",
						vim.lsp.buf.signature_help,
						vim.tbl_extend("force", opts, {
							desc = "Show LSP signature help",
						})
					)
					vim.keymap.set(
						"n",
						"<C-k>",
						vim.lsp.buf.signature_help,
						vim.tbl_extend("force", opts, {
							desc = "Show LSP signature help",
						})
					)
					-- NOTE: LSP refactoring keymaps (gr)
					-- https://github.com/neovim/neovim/pull/28650
					vim.keymap.set(
						"n",
						"grr",
						vim.lsp.buf.references,
						vim.tbl_extend("force", opts, {
							desc = "Goto references",
						})
					)
					vim.keymap.set(
						"n",
						"grn",
						function()
							return ":IncRename " .. vim.fn.expand("<cword>")
						end,
						vim.tbl_extend("force", opts, {
							desc = "Rename with LSP",
							expr = true,
						})
					)
					vim.keymap.set(
						{ "n", "x" },
						"gra",
						require("actions-preview").code_actions,
						vim.tbl_extend("force", opts, {
							desc = "Run code action",
						})
					)
					vim.keymap.set(
						"n",
						"grh",
						function()
							local is_enable =
								not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
							vim.lsp.inlay_hint.enable(is_enable, { bufnr = 0 })
						end,
						vim.tbl_extend("force", opts, {
							desc = "Toggle inlay hint",
						})
					)

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
						vim.api.nvim_clear_autocmds({
							group = augroup,
							buffer = buf,
						})
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
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities =
				require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						hint = {
							enable = true,
							setType = true,
						},
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

			vim.lsp.config("vtsls", {
				settings = {
					typescript = {
						updateImportsOnFileMove = "always",
						inlayHints = {
							parameterNames = {
								enabled = "literals",
							},
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = {
								enabled = true,
							},
							functionLikeReturnTypes = {
								enabled = true,
							},
							enumMemberValues = { enabled = true },
						},
					},
					javascript = {
						updateImportsOnFileMove = "always",
						inlayHints = {
							parameterNames = {
								enabled = "literals",
							},
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = {
								enabled = true,
							},
							functionLikeReturnTypes = {
								enabled = true,
							},
							enumMemberValues = { enabled = true },
						},
					},
					vtsls = {
						enableMoveToFileCodeAction = true,
					},
				},
			})

			vim.lsp.config("gopls", {
				cmd_env = { GOFUMPT_SPLIT_LONG_LINES = "on" },
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						gofumpt = true,
						analyses = {
							fillstruct = true,
						},
						vulncheck = "Imports",
					},
				},
			})

			vim.lsp.config("typos_lsp", {
				init_options = {
					diagnosticSeverity = "Hint",
				},
			})

			vim.lsp.config("biome", {})

			-- NOTE: user’s on_attach function override the default on_attach of eslint
			--       https://github.com/neovim/nvim-lspconfig/issues/3837
			local base_on_attach = vim.lsp.config.eslint.on_attach
			vim.lsp.config("eslint", {
				settings = {
					format = false,
				},
				on_attach = function(client, bufnr)
					if base_on_attach then
						base_on_attach(client, bufnr)
					end

					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "LspEslintFixAll",
					})
				end,
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			local schemas = require("schemastore").yaml.schemas({})

			schemas = vim.tbl_extend("error", schemas, {
				kubernetes = {
					"configmap*.yaml",
					"limitrange*.yaml",
					"namespace*.yaml",
					"pvc*.yaml",
					"pv*.yaml",
					"secret*.yaml",
					"serviceaccount*.yaml",
					"service*.yaml",
					"daemonset*.yaml",
					"deployment*.yaml",
					"statefulset*.yaml",
					"hpa*.yaml",
					"cronjob*.yaml",
					"job*.yaml",
					"ingress*.yaml",
					"networkpolicy*.yaml",
					"poddisruptionbudget*.yaml",
					"clusterrolebinding*.yaml",
					"clusterrole*.yaml",
					"rolebinding*.yaml",
					"role*.yaml",
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						customTags = {
							"!reference sequence",
						},
						schemaStore = {
							-- NOTE: disable built-in schemaStore support and use SchemaStore.nvim
							enable = false,
							-- NOTE: Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = schemas,
					},
				},
			})

			vim.lsp.config("harper_ls", {
				settings = {
					["harper-ls"] = {
						linters = {
							SentenceCapitalization = false,
							SpellCheck = false,
						},
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls", -- NOTE: require shellcheck for linting from bashls
					"biome",
					"buf_ls",
					"cssls",
					"docker_compose_language_service",
					"dockerls",
					"emmet_language_server",
					"eslint",
					"golangci_lint_ls",
					"gopls",
					"graphql",
					"harper_ls",
					"helm_ls",
					"hyprls",
					"jsonls",
					"just",
					"lua_ls",
					"marksman",
					"systemd_ls",
					"tailwindcss",
					"taplo",
					"terraformls",
					"tflint",
					"typos_lsp",
					"yamlls",
					"vale_ls",
					"vtsls",
				},
				automatic_enable = true,
			})

			-- NOTE: tilt_ls not support by mason-lspconfig
			vim.lsp.enable("tilt_ls")
		end,
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				dependencies = {
					{ "williamboman/mason.nvim" },
				},
			},
			{ "b0o/SchemaStore.nvim" },
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						vim.fn.stdpath("config") .. "/lua",
						vim.fn.expand("~/.config/yazi/plugins/types.yazi/"),
						"${3rd}/luv/library",
						"${3rd}/busted/library",
						"${3rd}/luassert/library",
					},
				},
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = function()
			local null_ls = require("null-ls")

			return {
				border = "single",
				sources = {
					null_ls.builtins.diagnostics.actionlint,
					null_ls.builtins.diagnostics.buf,
					null_ls.builtins.diagnostics.editorconfig_checker,
					null_ls.builtins.diagnostics.opacheck,
					null_ls.builtins.diagnostics.sqlfluff.with({
						extra_args = { "--dialect", "postgres" },
					}),
					null_ls.builtins.diagnostics.markdownlint_cli2,
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
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.diagnostics.selene,
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.diagnostics.zsh,
					null_ls.builtins.diagnostics.todo_comments,
					null_ls.builtins.code_actions.gomodifytags,
					null_ls.builtins.code_actions.impl,
				},
			}
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				sql_formatter = {
					prepend_args = {
						"-c",
						vim.fn.expand("~/.config/sql-formatter/config.json"),
					},
				},
			},
			formatters_by_ft = {
				hcl = { "hcl" },
				go = { "goimports", "golangci-lint", "gofumpt" },
				lua = { "stylua" },
				proto = { "buf" },
				rego = { "opa_fmt" },
				sql = { "sql_formatter" },
				mysql = { "sql_formatter" },
				just = { "just" },
				sh = { "shellharden", "shellcheck", "shfmt" },
				direnv = { "shellharden", "shfmt" },
				javascript = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				javascriptreact = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				typescript = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				typescriptreact = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				json = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				jsonc = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				markdown = { "prettier" },
				["markdown.mdx"] = { "prettier" },
				graphql = {
					"biome",
					"prettier",
					stop_after_first = true,
				},
				yaml = { "yamlfmt" },
				toml = { "taplo" },
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		opts = {
			hint_enable = false,
			handler_opts = {
				border = "single",
			},
		},
		config = function(_, opts)
			local buf = vim.api.nvim_get_current_buf()
			require("lsp_signature").on_attach(opts, buf)
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
		opts = function()
			local hl = require("actions-preview.highlight")
			return {
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
			}
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
							suffix = suffix
								.. (" "):rep(
									targetWidth - curWidth - chunkWidth
								)
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
			definition = {
				keys = {
					edit = "<C-c>o",
					vsplit = "<C-c>v",
					split = "<C-c>s",
					tabe = "<C-c>t",
					tabnew = "<C-c>n",
					quit = "q",
					close = "<C-c>k",
				},
			},
			lightbulb = {
				-- NOTE: prioritize diagnostic signs over lightbulb signs
				sign_priority = 1,
			},
			outline = {
				close_after_jump = true,
			},
			symbol_in_winbar = {
				enable = false,
			},
			ui = {
				border = "single",
				code_action = "󱐌",
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
		"Bekaboo/dropbar.nvim",
		-- NOTE: dropbar.nvim lazy load automatically
		lazy = false,
		init = function()
			vim.o.winbar = " "
		end,
		keys = {
			{
				"gr;",
				function()
					require("dropbar.api").pick()
				end,
				desc = "Pick symbols in winbar",
			},
			{
				"[;",
				function()
					require("dropbar.api").goto_context_start()
				end,
				desc = "Go to start of current context",
			},
			{
				"];",
				function()
					require("dropbar.api").select_next_context()
				end,
				desc = "Select next context",
			},
		},
		opts = {
			bar = {
				enable = function(buf, win, _)
					if
						not vim.api.nvim_buf_is_valid(buf)
						or not vim.api.nvim_win_is_valid(win)
						or vim.fn.win_gettype(win) ~= ""
						-- NOTE: enable winbar always
						-- or vim.wo[win].winbar ~= ""
						or vim.bo[buf].ft == "help"
					then
						return false
					end

					local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
					if stat and stat.size > 1024 * 1024 then
						return false
					end

					return vim.bo[buf].ft == "markdown"
						or pcall(vim.treesitter.get_parser, buf)
						or not vim.tbl_isempty(vim.lsp.get_clients({
							bufnr = buf,
							method = "textDocument/documentSymbol",
						}))
				end,
			},
		},
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
	},
}
