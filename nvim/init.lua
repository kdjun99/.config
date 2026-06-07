-- Disable netrw before startup directory handling so Neo-tree can take over
-- without briefly flashing the netrw directory UI on `nvim .`.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("kdjun")
