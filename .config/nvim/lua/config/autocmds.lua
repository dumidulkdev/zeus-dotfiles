-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Track latest nvim working project for Waybar Git module
local grp = vim.api.nvim_create_augroup("waybar_git_project", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "BufEnter" }, {
  group = grp,
  callback = function()
    local cwd = vim.fn.getcwd()
    local out = vim.fn.expand("~/.config/waybar/.last-nvim-project")
    pcall(vim.fn.mkdir, vim.fn.fnamemodify(out, ":h"), "p")
    pcall(vim.fn.writefile, { cwd }, out)
  end,
})
