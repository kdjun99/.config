local M = {}

local function terminal_tab(cmd)
    vim.cmd("tabnew")
    vim.fn.termopen(cmd, { cwd = vim.fn.getcwd() })
    vim.cmd("startinsert")
end

local function terminal_split()
    vim.cmd("botright 15split")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end

local function tmux_popup(cmd, title)
    if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
        vim.fn.jobstart({
            "tmux", "display-popup",
            "-d", vim.fn.getcwd(),
            "-w", "90%",
            "-h", "90%",
            "-T", title,
            "-E", vim.env.SHELL .. " -lc " .. vim.fn.shellescape("exec " .. cmd),
        }, { detach = true })
    else
        terminal_tab(cmd)
    end
end

function M.setup()
    vim.keymap.set("n", "<leader>gg", function()
        tmux_popup("lazygit", "lazygit")
    end, { desc = "Git: lazygit popup" })

    vim.keymap.set("n", "<leader>gy", function()
        tmux_popup("yazi", "yazi")
    end, { desc = "Files: yazi popup" })

    vim.keymap.set("n", "<leader>tt", terminal_split, { desc = "Terminal: split" })
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })
end

return M
