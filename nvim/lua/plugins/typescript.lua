return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.g.vtsls_tsdk then
        opts.servers = opts.servers or {}
        opts.servers.vtsls = opts.servers.vtsls or {}
        opts.servers.vtsls.settings = vim.tbl_deep_extend("force", opts.servers.vtsls.settings or {}, {
          typescript = {
            tsdk = vim.g.vtsls_tsdk,
          },
        })
      end
    end,
  },
}
