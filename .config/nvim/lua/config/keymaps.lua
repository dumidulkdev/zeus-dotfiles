-- VS Code-like keymaps (best effort in terminal Neovim)
-- Note: some combos (like Ctrl+Shift+Arrow) depend on terminal support.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>w<CR>", opts)

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- Copy / Cut / Paste using system clipboard
map("v", "<C-c>", '"+y', opts)
map("n", "<C-c>", '"+yy', opts) -- VSCode-like: copy current line when no selection
map("v", "<C-x>", '"+d', opts)
map("n", "<C-x>", '"+dd', opts)
map("n", "<C-v>", '"+p', opts)
map("i", "<C-v>", '<C-r>+', opts)
map("v", "<C-v>", '"+p', opts)

-- Undo / Redo
map("n", "<C-z>", "u", opts)
map("i", "<C-z>", "<Esc>u", opts)
map("n", "<C-y>", "<C-r>", opts)

-- Find in files (VSCode Ctrl+Shift+F equivalent)
map("n", "<C-S-f>", function()
  Snacks.picker.grep()
end, opts)

-- File finder (VSCode Ctrl+P equivalent)
map("n", "<C-p>", function()
  Snacks.picker.files()
end, opts)

-- VSCode-like terminal toggle (Ctrl+J)
-- In terminal-job mode, <C-j> is normally sent to shell, so map separately.
map({ "n", "i", "v" }, "<C-j>", function()
  Snacks.terminal()
end, opts)

-- NOTE: <C-j> in terminal-mode is ASCII LF (same as Enter), so it can't be
-- reliably distinguished from normal input for hiding the terminal.
-- Use Alt+J to hide terminal while in terminal-job mode.
map("t", "<A-j>", [[<C-\><C-n><cmd>close<CR>]], opts)

-- VSCode-like selection with Shift+Arrow (char-wise)
map("n", "<S-Left>", "v<Left>", opts)
map("n", "<S-Right>", "v<Right>", opts)
map("n", "<S-Up>", "v<Up>", opts)
map("n", "<S-Down>", "v<Down>", opts)
map("v", "<S-Left>", "<Left>", opts)
map("v", "<S-Right>", "<Right>", opts)
map("v", "<S-Up>", "<Up>", opts)
map("v", "<S-Down>", "<Down>", opts)
map("i", "<S-Left>", "<Esc>v<Left>", opts)
map("i", "<S-Right>", "<Esc>v<Right>", opts)
map("i", "<S-Up>", "<Esc>v<Up>", opts)
map("i", "<S-Down>", "<Esc>v<Down>", opts)

-- VSCode-like word selection with Ctrl+Shift+Arrow
map("n", "<C-S-Left>", "vB", opts)
map("n", "<C-S-Right>", "vE", opts)
map("v", "<C-S-Left>", "B", opts)
map("v", "<C-S-Right>", "E", opts)
map("i", "<C-S-Left>", "<Esc>vB", opts)
map("i", "<C-S-Right>", "<Esc>vE", opts)
