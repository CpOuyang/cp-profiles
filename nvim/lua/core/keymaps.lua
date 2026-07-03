local map = vim.keymap.set
local opts = { silent = true }

local function next_buffer()
  vim.cmd.bnext()
end

local function previous_buffer()
  vim.cmd.bprevious()
end

local function focus_file_window()
  local current_win = vim.api.nvim_get_current_win()

  vim.cmd.wincmd("l")
  if vim.bo.filetype ~= "netrw" then
    return true
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "netrw" and vim.bo[buf].buftype == "" then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end

  vim.api.nvim_set_current_win(current_win)
  return false
end

local function smart_quit()
  if vim.bo.filetype == "netrw" and vim.fn.winnr("$") > 1 then
    if not focus_file_window() then
      vim.cmd.quit()
      return
    end
  end

  local listed_buffers = vim.tbl_filter(function(buf)
    return vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  if vim.bo.buftype == "" and vim.bo.buflisted and #listed_buffers > 1 then
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd.bprevious()
    if vim.api.nvim_get_current_buf() == current_buf then
      vim.cmd.bnext()
    end
    vim.cmd.bdelete(current_buf)
  else
    vim.cmd.quit()
  end
end

vim.api.nvim_create_user_command("CpSmartQuit", smart_quit, {})

vim.cmd([[cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() ==# 'q' ? 'CpSmartQuit' : 'q']])

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Tab navigation
map("n", "<leader>1", "1gt", opts)
map("n", "<leader>2", "2gt", opts)
map("n", "<leader>3", "3gt", opts)
map("n", "<leader>4", "4gt", opts)

-- Clear search highlight
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Open buffer navigation
map("n", "<Tab>", next_buffer, opts)
map("n", "<S-Tab>", previous_buffer, opts)
map("n", "<BackTab>", previous_buffer, opts)
map("n", "<leader><leader>", "<C-^>", opts)
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)

-- Toggle relative number
map("n", "<leader>rn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, opts)

-- Buffer operations
map("n", "<leader>bd", ":bdelete<CR>", opts)
map("n", "<leader>bn", next_buffer, opts)
map("n", "<leader>bp", previous_buffer, opts)
map("n", "<leader>e", ":Lexplore<CR>", opts)

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>ld", vim.diagnostic.open_float, opts)
map("n", "<leader>lq", vim.diagnostic.setloclist, opts)
map("n", "<leader>ll", vim.diagnostic.setqflist, opts)
