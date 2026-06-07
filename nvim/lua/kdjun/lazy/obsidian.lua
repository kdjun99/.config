return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	cmd = "Obsidian",
	keys = {
		-- capture
		{ "<leader>nn", "<cmd>Obsidian new<CR>", desc = "Notes: new note" },
		{ "<leader>nd", "<cmd>Obsidian today<CR>", desc = "Notes: daily note" },
		{ "<leader>ny", "<cmd>Obsidian yesterday<CR>", desc = "Notes: yesterday's note" },
		{ "<leader>ni", "<cmd>edit ~/notes/inbox.md<CR>", desc = "Notes: inbox" },
		-- navigate
		{ "<leader>nf", "<cmd>Obsidian quick_switch<CR>", desc = "Notes: find note" },
		{ "<leader>ns", "<cmd>Obsidian search<CR>", desc = "Notes: search notes" },
		{ "<leader>nb", "<cmd>Obsidian backlinks<CR>", desc = "Notes: backlinks" },
		{ "<leader>nt", "<cmd>Obsidian tags<CR>", desc = "Notes: tags" },
		-- link
		{ "<leader>nl", "<cmd>Obsidian link<CR>", mode = "v", desc = "Notes: link selection to existing note" },
		{ "<leader>nN", "<cmd>Obsidian link_new<CR>", mode = "v", desc = "Notes: link selection to new note" },
		{ "<leader>nx", "<cmd>Obsidian extract_note<CR>", mode = "v", desc = "Notes: extract selection into note" },
		{ "<leader>np", "<cmd>Obsidian paste_img<CR>", desc = "Notes: paste image from clipboard" },
		-- act
		{ "<leader>nc", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Notes: toggle checkbox" },
		-- smart_action: follow link under cursor / toggle checkbox on a task line
		{ "<CR>", "<cmd>Obsidian smart_action<CR>", ft = "markdown", desc = "Notes: follow link / toggle checkbox" },
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		legacy_commands = false,
		-- More specific paths must come before their parent directories
		-- so workspace detection picks the right vault.
		workspaces = {
			{ name = "notes", path = "~/notes" },
			{ name = "linkareer-study", path = "~/dev/linkareer/linkareer-study" },
			{ name = "linkareer", path = "~/dev/linkareer" },
			{ name = "pi", path = "~/.workspace/pi" },
			{ name = "interview-reviewing", path = "~/Downloads/interview/reviewing" },
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = "daily.md",
		},
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		-- Human-readable filenames: "마감일 산정 기준" -> 마감일-산정-기준.md
		-- (falls back to a timestamp when no title is given)
		note_id_func = function(title)
			if title ~= nil and title ~= "" then
				return title:gsub("%s+", "-"):gsub("[/\\:*?\"<>|]", "")
			end
			return os.date("%Y%m%d-%H%M%S")
		end,
		-- [[wiki-link]] completion is provided by the built-in obsidian-ls
		-- LSP server (picked up by blink.cmp's lsp source automatically).
		picker = {
			name = "telescope.nvim",
		},
		-- render-markdown.nvim owns markdown rendering; avoid double UI.
		ui = { enable = false },
	},
}
