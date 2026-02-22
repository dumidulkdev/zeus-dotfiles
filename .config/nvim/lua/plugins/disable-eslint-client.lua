return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "eslint" then
            vim.schedule(function()
              vim.lsp.buf_detach_client(args.buf, client.id)
            end)
          end
        end,
      })
    end,
  },
}
