require("kdjun.remap")
require("kdjun.lazy_init")
require("kdjun.set")
require("kdjun.devflow").setup()

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local kdjunGroup = augroup("kdjun", {})

-- Yank highlight
autocmd("TextYankPost", {
    group = kdjunGroup,
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Trim trailing whitespace on save
autocmd("BufWritePre", {
    group = kdjunGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
