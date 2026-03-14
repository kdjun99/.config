return {
  {
    dir = "~/.config/nvim/pack/colors/opt/dracula_pro",
    name = "dracula_pro",
    lazy = false,
    priority = 1000,
    config = function()
      -- 필요한 변수 정의
      vim.g.dracula_colorterm = 0
      -- (필요한 다른 g: 변수도 여기에 정의해줄 수 있음)
      vim.cmd("colorscheme dracula_pro")
    end,
  },
}
