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
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Markdown: prose, not code — no 80-col guide, soft-wrap long lines
autocmd("FileType", {
    group = kdjunGroup,
    pattern = "markdown",
    callback = function()
        vim.opt_local.colorcolumn = ""
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- Trim trailing whitespace on save
-- (markdown excluded: two trailing spaces are a hard line break)
autocmd("BufWritePre", {
    group = kdjunGroup,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "markdown" then
            return
        end
        vim.cmd([[%s/\s\+$//e]])
    end,
})
