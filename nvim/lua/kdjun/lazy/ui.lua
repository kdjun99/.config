return {
	{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "nvim-tree/nvim-web-devicons" },
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.comment").setup()

			local starter = require("mini.starter")
			local open_file_explorer = function()
				require("neo-tree.command").execute({
					action = "focus",
					source = "filesystem",
					position = "float",
					dir = vim.fn.getcwd(),
				})
			end

			starter.setup({
				evaluate_single = true,
				header = table.concat({
					"╭────────────────────────╮",
					"│       kdjun.nvim      │",
					"╰────────────────────────╯",
					"",
					"Fast project cockpit · <Space>p",
				}, "\n"),
				items = {
					{ name = "  Find files", action = "Telescope find_files", section = "Quick actions" },
					{ name = "󰱼  Live grep", action = "Telescope live_grep", section = "Quick actions" },
					{ name = "󰙅  File explorer", action = open_file_explorer, section = "Quick actions" },
					{ name = "  Edit config", action = "edit ~/.config/nvim", section = "Quick actions" },
					{ name = "󰒲  Lazy plugins", action = "Lazy", section = "Quick actions" },
					{ name = "󰩈  Quit", action = "qa", section = "Quick actions" },
					starter.sections.recent_files(6, false, true),
					starter.sections.recent_files(6, true, false),
				},
				content_hooks = {
					starter.gen_hook.adding_bullet("  "),
					starter.gen_hook.indexing("all", { "Builtin actions" }),
					starter.gen_hook.padding(0, 1),
					starter.gen_hook.aligning("center", "center"),
				},
				footer = "<CR> open  ·  type prefix to filter  ·  <C-c> close",
			})
		end,
	},
	{ "NMAC427/guess-indent.nvim", opts = {} },
}
