return {
	{
		dir = "~/.config/nvim/themes/dracula_pro",
		name = "dracula_pro",
		lazy = false,
		priority = 1000,
		config = function()
			local function is_dark_mode()
				local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
				if not handle then
					return true -- fall back to dark when detection fails
				end
				local result = handle:read("*a") or ""
				handle:close()
				return result:match("Dark") ~= nil
			end

			local function apply_theme()
				local dark_mode = is_dark_mode()
				if dark_mode then
					vim.opt.background = "dark"
					vim.cmd.colorscheme("dracula_pro_van_helsing")
				else
					vim.opt.background = "light"
					vim.cmd.colorscheme("dracula_pro_alucard")
				end
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

				local cursor = dark_mode
					and { fg = "#282a36", bg = "#f8f8f2" }
					or { fg = "#f8f8f2", bg = "#282a36" }
				vim.api.nvim_set_hl(0, "Cursor", cursor)
				vim.api.nvim_set_hl(0, "lCursor", cursor)
				vim.api.nvim_set_hl(0, "CursorIM", cursor)
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
