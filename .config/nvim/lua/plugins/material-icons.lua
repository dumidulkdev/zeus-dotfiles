return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        [".env"] = { icon = "", color = "#eab308", name = "Env" },
        [".env.local"] = { icon = "", color = "#f59e0b", name = "EnvLocal" },
      },
    },
  },
}
