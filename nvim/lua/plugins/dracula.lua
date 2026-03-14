return {
  {
    dir = "~/.config/nvim/pack/colors/opt/dracula_pro",
    name = "dracula_pro",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.dracula_colorterm = 0
      vim.cmd("colorscheme dracula_pro_van_helsing")
    end,
  },
}

