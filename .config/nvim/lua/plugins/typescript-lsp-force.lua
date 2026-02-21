return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}
      -- Force-enable TS LSP explicitly
      opts.servers.vtsls = opts.servers.vtsls or {}
      return opts
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "vtsls") then
        table.insert(opts.ensure_installed, "vtsls")
      end
      return opts
    end,
  },
}
