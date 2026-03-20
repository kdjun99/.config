return {
	dir = "~/.config/nvim/themes/dracula_pro",
	name = "dracula_pro",
	config = function()
		local function is_dark_mode()
			if vim.fn.has("macunix") == 1 then
				local ok, out = pcall(vim.fn.system, { "defaults", "read", "-g", "AppleInterfaceStyle" })
				return ok and out:match("Dark")
			end
			if vim.fn.executable("gsettings") == 1 then
				local ok, out =
					pcall(vim.fn.system, { "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" })
				return ok and out:match("[dD]ark")
			end
			return false
		end

		local function apply_theme()
			if is_dark_mode() then
				vim.cmd.colorscheme("dracula_pro_van_helsing")
			else
				vim.cmd.colorscheme("dracula_pro_van_helsing")
				-- vim.cmd.colorscheme("dracula_pro_alucard")
			end
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end

		apply_theme()

		vim.api.nvim_create_autocmd("FocusGained", {
			callback = apply_theme,
		})
	end,
}
