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
		end,
	},
	{ "NMAC427/guess-indent.nvim", opts = {} },
}
