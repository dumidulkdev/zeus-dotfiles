return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.update_in_insert = true
      opts.diagnostics.virtual_text = true
      opts.diagnostics.severity_sort = true
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "TextChangedI" },
    },
  },
}
