local opts = { noremap = true, silent = true, nowait = true }
local keymap = vim.api.nvim_set_keymap

-- nvim-tree
keymap("n", "<F10>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<space>f", ":NvimTreeFindFileToggle<CR>", opts)

-- telescope
keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<C-l>", "<cmd>lua require('telescope.builtin').buffers({sort_mru = true})<CR>", opts)
keymap(
  "n",
  "<C-s>",
  "<cmd>lua require('telescope.builtin').lsp_document_symbols({ symbols = {'class', 'method', 'function'} })<CR>",
  opts
)
keymap("n", "<space>r", ":Telescope neoclip plus<CR>", opts)

-- hop
keymap("n", "<C-j>", ":HopWord<CR>", opts)

-- neogen
keymap("n", "<leader>f", ":Neogen func<CR>", opts)
keymap("n", "<leader>c", ":Neogen class<CR>", opts)

-- toggleterm
keymap("n", "<c-g>", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("t", "<C-\\>", "<C-\\><C-n>", opts)

-- bufferline
keymap("n", "<leader>]", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<leader>[", ":BufferLineCyclePrev<CR>", opts)
for i = 1, 9, 1 do
  keymap("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", opts)
end

-- general
keymap("n", "<space>c", ":cclose<CR>", opts)
keymap("n", "<leader>a", ":Rg <cword><CR>", opts)
