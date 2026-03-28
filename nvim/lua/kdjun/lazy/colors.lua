return {
	{
		dir = "~/.config/nvim/themes/dracula_pro",
		name = "dracula_pro",
		lazy = false,
		priority = 1000,
		config = function()
			local function is_dark_mode()
				local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
				local result = handle:read("*a")
				handle:close()
				return result:match("Dark") ~= nil
			end

			local function apply_theme()
				if is_dark_mode() then
					vim.opt.background = "dark"
					vim.cmd.colorscheme("dracula_pro_van_helsing")
				else
					vim.opt.background = "light"
					vim.cmd.colorscheme("dracula_pro_alucard")
				end
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end

			apply_theme()

			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					apply_theme()
				end,
			})
		end,
	},
	{
		"webhooked/kanso.nvim",
		lazy = true,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
	},
}
