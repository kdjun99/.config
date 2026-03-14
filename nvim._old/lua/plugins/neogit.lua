return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<C-S-g>", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
          diffview = true,
        },
      })
    end,
  },
}