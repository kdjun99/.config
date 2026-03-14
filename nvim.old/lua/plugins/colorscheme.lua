return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				options = {
					--transparent = true,
				},
			}
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1500,
		opts = function()
			return {
				--transparent = true,
			}
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = function()
			return {
				styles = {
					bold = true,
					italic = true,
					--transparency = true,
				},
			}
		end,
	},
}
