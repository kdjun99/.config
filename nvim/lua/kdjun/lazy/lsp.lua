return {
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = { "rafamadriz/friendly-snippets" },
		lazy = false,
		opts = {
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = { enabled = true },
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			cmdline = {
				enabled = true,
			},
			keymap = {
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-y>"] = { "select_and_accept" },
				["<C-Space>"] = { "show" },
				["<C-e>"] = { "cancel", "fallback" },
			},
		},
	},
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"vtsls",
					"gopls",
					"pyright",
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					winblend = 0,
					normal_hl = "Comment",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"j-hui/fidget.nvim",
			"saghen/blink.cmp",
			"yioneko/nvim-vtsls",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- nvim-vtsls: registers `:VtsExec` user command and command helpers
			require("vtsls").config({})

			-- vtsls
			local ts_settings = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
			}
			if vim.g.vtsls_tsdk then
				ts_settings.tsdk = vim.g.vtsls_tsdk
			end

			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				settings = {
					vtsls = {
						autoUseWorkspaceTsdk = true,
						enableMoveToFileCodeAction = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = ts_settings,
					javascript = vim.tbl_deep_extend("force", {}, ts_settings),
				},
			})

			-- Disable ts_ls to prevent conflict with vtsls
			vim.lsp.config("ts_ls", { enabled = false })

			-- lua_ls
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						format = {
							enable = true,
							defaultConfig = {
								indent_style = "space",
								indent_size = "2",
							},
						},
					},
				},
			})

			-- gopls, pyright with capabilities
			vim.lsp.config("gopls", { capabilities = capabilities })
			vim.lsp.config("pyright", { capabilities = capabilities })

			-- Enable servers
			vim.lsp.enable({ "vtsls", "lua_ls", "gopls", "pyright" })

			-- Keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, remap = false }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- vtsls smart `gd`: textDocument/definition + auto-follow-through.
					-- Standard definition is used (works on any TS version, no crash).
					-- If the result lands on an `import` line in the same file, we
					-- chain another definition call from there to follow through to
					-- the actual source location. This avoids `goToSourceDefinition`
					-- entirely (which requires TS 4.7+ and crashes vtsls 0.3.0 on
					-- TypeScript < 4.7 projects like linkareer-main).
					if client and client.name == "vtsls" then
						vim.keymap.set("n", "gd", function()
							local origin_buf = vim.api.nvim_get_current_buf()
							local origin_line = vim.api.nvim_win_get_cursor(0)[1]

							vim.lsp.buf.definition({
								on_list = function(options)
									local items = options.items or {}
									if #items == 0 then
										return
									end
									local first = items[1]
									local origin_filename = vim.api.nvim_buf_get_name(origin_buf)
									local same_buf = (first.bufnr == origin_buf)
										or (first.filename == origin_filename)
									local follow_through = false

									if same_buf and first.lnum ~= origin_line then
										local line = vim.api.nvim_buf_get_lines(
											origin_buf, first.lnum - 1, first.lnum, false
										)[1] or ""
										if line:match("^%s*import%s") then
											follow_through = true
										end
									end

									if follow_through then
										-- Jump to import line, then chain another definition call.
										vim.cmd("normal! m'") -- save jumplist
										vim.api.nvim_win_set_cursor(0, {
											first.lnum,
											math.max(first.col - 1, 0),
										})
										vim.schedule(function()
											vim.lsp.buf.definition()
										end)
									else
										-- Default behavior: jump for single, quickfix for multiple.
										if #items == 1 then
											vim.cmd("normal! m'")
											local target_buf = first.bufnr or vim.fn.bufadd(first.filename)
											vim.bo[target_buf].buflisted = true
											vim.api.nvim_win_set_buf(0, target_buf)
											vim.api.nvim_win_set_cursor(0, {
												first.lnum,
												math.max(first.col - 1, 0),
											})
										else
											vim.fn.setqflist({}, " ", options)
											vim.cmd("botright copen")
										end
									end
								end,
							})
						end, opts)
					end

					-- Builtin (0.11): gd=definition, K=hover, grr=references, grn=rename, gra=code_action, gri=implementation
					vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.workspace_symbol() end, opts)
					vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
					vim.keymap.set("n", "<leader>ll", "<cmd>Telescope diagnostics<CR>", opts)
					vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
				end,
			})

			vim.diagnostic.config({
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
