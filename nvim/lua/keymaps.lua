local opts = { noremap = true, silent = true, nowait = true }
local keymap = vim.api.nvim_set_keymap

-- General
keymap("n", "<C-h>", ":tabp<CR>", opts)
keymap("n", "<C-l>", ":tabn<CR>", opts)
