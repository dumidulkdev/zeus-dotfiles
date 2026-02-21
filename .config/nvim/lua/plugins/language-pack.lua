return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      -- Common language servers
      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.ts_ls = opts.servers.ts_ls or {}
      opts.servers.eslint = opts.servers.eslint or {}
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.bashls = opts.servers.bashls or {}
      opts.servers.jsonls = opts.servers.jsonls or {}
      opts.servers.yamlls = opts.servers.yamlls or {}
      opts.servers.dockerls = opts.servers.dockerls or {}
      opts.servers.docker_compose_language_service = opts.servers.docker_compose_language_service or {}

      return opts
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}

      local wanted = {
        "vtsls",
        "ts_ls",
        "eslint",
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "dockerls",
        "docker_compose_language_service",
      }

      for _, server in ipairs(wanted) do
        if not vim.tbl_contains(opts.ensure_installed, server) then
          table.insert(opts.ensure_installed, server)
        end
      end

      return opts
    end,
  },
}
