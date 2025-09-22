local group = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local yank_group = group("CpHighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

-- Restore cursor position when reopening files
local lastloc = group("CpLastLocation", { clear = true })
autocmd("BufReadPost", {
  group = lastloc,
  callback = function(event)
    local ft = vim.bo[event.buf].filetype
    if ft:match("commit") or ft:match("rebase") then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Filetype-specific indentation
local indent_group = group("CpIndent", { clear = true })
autocmd("FileType", {
  group = indent_group,
  pattern = { "lua", "javascript", "typescript", "json", "yaml", "helm", "html", "css" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

autocmd("FileType", {
  group = indent_group,
  pattern = { "go", "make", "proto" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- When opening help, make it vertical
autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.cmd.wincmd("L")
  end,
})
