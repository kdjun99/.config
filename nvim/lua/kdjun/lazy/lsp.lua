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
	{ "j-hui/fidget.nvim", opts = {} },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"j-hui/fidget.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

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
					vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
					vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
					vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
					vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
					vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
					vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
					vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
					vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
					vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
					vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
					vim.keymap.set("n", "<leader>vl", "<cmd>Telescope diagnostics<CR>", opts)
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
