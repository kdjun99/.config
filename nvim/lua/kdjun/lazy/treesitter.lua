return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"vimdoc", "javascript", "typescript", "lua", "bash",
				"json", "html", "css", "tsx", "yaml", "markdown",
				"markdown_inline", "python", "go", "rust",
			},
			sync_install = false,
			auto_install = true,
			indent = { enable = true },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_prev_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
					},
				},
			},
		})

		require("treesitter-context").setup({
			enable = true,
			max_lines = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
		})
	end,
}
