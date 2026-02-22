return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.diagnostics = opts.diagnostics or {}

      -- Show only real compiler/LSP errors in editor view
      opts.diagnostics.update_in_insert = true
      opts.diagnostics.severity_sort = true
      opts.diagnostics.virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } }
      opts.diagnostics.underline = { severity = { min = vim.diagnostic.severity.ERROR } }

      -- Filter out lint/format diagnostics (eslint/prettier) from display
      local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(d)
            local src = (d.source or ""):lower()
            local msg = (d.message or ""):lower()
            if src:find("eslint", 1, true) or src:find("prettier", 1, true) then
              return false
            end
            -- hide lint-style rewrite hints (replace/insert/delete suggestions)
            if msg:find("replace `", 1, true) or msg:find("insert `", 1, true) or msg:find("delete `", 1, true) then
              return false
            end
            return true
          end, result.diagnostics)
        end
        return orig(err, result, ctx, config)
      end

      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
  },
}
