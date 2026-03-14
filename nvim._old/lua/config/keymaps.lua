-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================================
-- Mac VSCode-like Keymaps
-- ============================================================================

-- File Operations
vim.keymap.set({"n", "i", "v"}, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set({"n", "i"}, "<D-n>", "<cmd>enew<cr>", { desc = "New file" })
vim.keymap.set("n", "<D-w>", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Clipboard Operations (Cmd+C/V/X/A)
vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({"n", "i"}, "<D-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("v", "<D-x>", '"+d', { desc = "Cut to clipboard" })
vim.keymap.set({"n", "i", "v"}, "<D-a>", "<esc>ggVG", { desc = "Select all" })

-- Undo/Redo (Cmd+Z/Shift+Cmd+Z)
vim.keymap.set({"n", "i"}, "<D-z>", "<cmd>undo<cr>", { desc = "Undo" })
vim.keymap.set({"n", "i"}, "<D-S-z>", "<cmd>redo<cr>", { desc = "Redo" })

-- Search and Navigation (Cmd+P/F/G)
vim.keymap.set({"n", "i"}, "<D-p>", "<cmd>Telescope find_files<cr>", { desc = "Quick Open" })
vim.keymap.set({"n", "i"}, "<D-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in file" })
vim.keymap.set({"n", "i"}, "<D-g>", function()
  local line = vim.fn.input("Go to line: ")
  if line ~= "" then
    vim.cmd(":" .. line)
  end
end, { desc = "Go to line" })

-- Find and Replace (Cmd+Option+F)
vim.keymap.set("n", "<D-A-f>", function()
  if LazyVim.has("grug-far.nvim") then
    require("grug-far").open()
  else
    vim.cmd("Telescope live_grep")
  end
end, { desc = "Find and Replace" })

-- Command Palette (Cmd+Shift+P)
vim.keymap.set({"n", "i"}, "<D-S-p>", "<cmd>Telescope commands<cr>", { desc = "Command Palette" })

-- Tab Navigation (Cmd+Shift+]/[)
vim.keymap.set("n", "<D-S-]>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<D-S-[>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Close tab (Cmd+W)
vim.keymap.set("n", "<D-w>", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Toggle sidebar (Cmd+B)
vim.keymap.set({"n", "i"}, "<D-b>", function()
  if LazyVim.has("neo-tree.nvim") then
    require("neo-tree.command").execute({ action = "toggle" })
  else
    vim.cmd("Explore")
  end
end, { desc = "Toggle File Explorer" })

-- Toggle terminal (Cmd+`)
vim.keymap.set({"n", "i", "t"}, "<D-`>", function() 
  if LazyVim.has("snacks.nvim") then
    Snacks.terminal.toggle() 
  else
    vim.cmd("terminal")
  end
end, { desc = "Toggle Terminal" })

-- ============================================================================
-- TypeScript/Development Specific (Mac)
-- ============================================================================

-- Format document (Shift+Option+F)
vim.keymap.set({"n", "v"}, "<S-A-f>", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format Document" })

-- Rename symbol (F2)
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Go to definition (F12 or Cmd+Click)
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<D-MouseLeftRelease>", vim.lsp.buf.definition, { desc = "Go to Definition" })

-- Show references (Shift+F12)
vim.keymap.set("n", "<S-F12>", vim.lsp.buf.references, { desc = "Show References" })

-- Code actions (Cmd+.)
vim.keymap.set("n", "<D-.>", vim.lsp.buf.code_action, { desc = "Code Actions" })

-- Quick fix (Cmd+Shift+.)
vim.keymap.set("n", "<D-S-.>", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.isPreferred
    end,
    apply = true,
  })
end, { desc = "Auto Fix" })

-- Show hover (Option+Space or K)
vim.keymap.set("n", "<A-Space>", vim.lsp.buf.hover, { desc = "Show Hover" })

-- Go to next/previous error (F8/Shift+F8)
vim.keymap.set("n", "<F8>", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<S-F8>", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

-- Show problems panel (Cmd+Shift+M)
vim.keymap.set("n", "<D-S-m>", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "Toggle Diagnostics" })

-- ============================================================================
-- Code Editing (Mac VSCode-like)
-- ============================================================================

-- Move lines up/down (Option+Up/Down)
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Duplicate line (Shift+Option+Up/Down)
vim.keymap.set("n", "<S-A-Up>", "<cmd>t-1<cr>", { desc = "Duplicate line up" })
vim.keymap.set("n", "<S-A-Down>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
vim.keymap.set("i", "<S-A-Up>", "<esc><cmd>t-1<cr>gi", { desc = "Duplicate line up" })
vim.keymap.set("i", "<S-A-Down>", "<esc><cmd>t.<cr>gi", { desc = "Duplicate line down" })

-- Comment toggle (Cmd+/)
vim.keymap.set({"n", "v"}, "<D-/>", function()
  if LazyVim.has("Comment.nvim") then
    require("Comment.api").toggle.linewise.current()
  else
    vim.cmd("normal gcc")
  end
end, { desc = "Toggle Comment" })

-- Multi-cursor (Cmd+D for next occurrence)
vim.keymap.set({"n", "x"}, "<D-d>", function()
  require("flash").jump({
    pattern = vim.fn.expand("<cword>"),
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      max_length = 0,
    },
    highlight = { matches = false },
    jump = { jumplist = true },
    remote_op = { restore = true, motion = true },
  })
end, { desc = "Select next occurrence" })

-- ============================================================================
-- Panel and Window Management
-- ============================================================================

-- Split editor (Cmd+\)
vim.keymap.set("n", "<D-\\>", "<cmd>vsplit<cr>", { desc = "Split editor right" })

-- Focus editor groups (Cmd+1/2/3)
vim.keymap.set("n", "<D-1>", "1<C-w>w", { desc = "Focus editor group 1" })
vim.keymap.set("n", "<D-2>", "2<C-w>w", { desc = "Focus editor group 2" })
vim.keymap.set("n", "<D-3>", "3<C-w>w", { desc = "Focus editor group 3" })

-- Navigate between editor groups (Cmd+Option+Left/Right)
vim.keymap.set("n", "<D-A-Left>", "<C-w>h", { desc = "Focus left editor group" })
vim.keymap.set("n", "<D-A-Right>", "<C-w>l", { desc = "Focus right editor group" })

-- Zen mode (Cmd+K Z)
vim.keymap.set("n", "<D-k>z", function()
  if LazyVim.has("zen-mode.nvim") then
    require("zen-mode").toggle()
  else
    vim.cmd("only")
  end
end, { desc = "Toggle Zen Mode" })

-- ============================================================================
-- Git Integration
-- ============================================================================

-- Source control (Ctrl+Shift+G)
vim.keymap.set("n", "<C-S-g>", function()
  if LazyVim.has("neogit") then
    require("neogit").open()
  elseif LazyVim.has("fugitive.vim") then
    vim.cmd("Git")
  else
    vim.cmd("Telescope git_status")
  end
end, { desc = "Open Git" })

-- Git blame
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
