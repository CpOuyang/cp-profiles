local opts = { noremap = true, silent = true, nowait = true }
local keymap = vim.api.nvim_set_keymap

-- General
keymap("n", "H", ":tabprevious<CR>", opts)
keymap("n", "L", ":tabnext<CR>", opts)
