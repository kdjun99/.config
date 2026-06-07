local function has_real_file_buffer()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr)
			and vim.bo[bufnr].buflisted
			and vim.bo[bufnr].buftype == ""
			and vim.api.nvim_buf_get_name(bufnr) ~= ""
		then
			return true
		end
	end

	return false
end

local function close_or_open_starter()
	vim.cmd("Neotree close")
	vim.schedule(function()
		if has_real_file_buffer() then
			return
		end

		local ok, starter = pcall(require, "mini.starter")
		if ok then
			starter.open()
		end
	end)
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false,
	cmd = "Neotree",
	keys = {
		{
			"<leader>pv",
			"<cmd>Neotree toggle filesystem reveal float<CR>",
			desc = "Files: floating explorer reveal",
		},
		{
			"<leader>pV",
			"<cmd>Neotree toggle filesystem reveal left<CR>",
			desc = "Files: sidebar explorer reveal",
		},
		{
			"<leader>pb",
			"<cmd>Neotree toggle buffers float<CR>",
			desc = "Files: buffer explorer",
		},
		{
			"<leader>pg",
			"<cmd>Neotree float git_status<CR>",
			desc = "Files: git status explorer",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		source_selector = {
			winbar = true,
			statusline = false,
		},
		window = {
			position = "left",
			width = 35,
			mappings = {
				["<Esc>"] = close_or_open_starter,
				["q"] = close_or_open_starter,
				["P"] = {
					"toggle_preview",
					config = {
						use_float = true,
					},
				},
			},
		},
		filesystem = {
			bind_to_cwd = true,
			window = {
				mappings = {
					["<Esc>"] = close_or_open_starter,
					["q"] = close_or_open_starter,
				},
			},
			follow_current_file = {
				enabled = true,
			},
			use_libuv_file_watcher = true,
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		},
		buffers = {
			window = {
				mappings = {
					["<Esc>"] = close_or_open_starter,
					["q"] = close_or_open_starter,
				},
			},
			follow_current_file = {
				enabled = true,
			},
		},
	},
}
