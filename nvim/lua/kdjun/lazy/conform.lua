return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		-- Markdown is excluded from autoformat so prettier doesn't rewrite
		-- notes on save; manual <leader>f formatting still works.
		format_on_save = function(bufnr)
			if vim.bo[bufnr].filetype == "markdown" then
				return nil
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			python = { "ruff_format" },
			go = { "gofumpt" },
		},
	},
}
