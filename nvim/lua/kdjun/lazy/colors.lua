return {
	dir = "~/.config/nvim/themes/dracula_pro",
	name = "dracula_pro",
	config = function()
		vim.cmd.colorscheme("dracula_pro_van_helsing")
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end,
}
