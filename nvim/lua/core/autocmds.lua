local group = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Netrw defines buffer-local Ctrl-h/l mappings that override window navigation.
local netrw_group = group("CpNetrwNavigation", { clear = true })
autocmd("FileType", {
  group = netrw_group,
  pattern = "netrw",
  callback = function(event)
    for _, direction in ipairs({ "h", "j", "k", "l" }) do
      vim.keymap.set("n", "<C-" .. direction .. ">", "<C-w>" .. direction, {
        buffer = event.buf,
        silent = true,
        desc = "Move to window " .. direction,
      })
    end
  end,
})

-- Highlight on yank
local yank_group = group("CpHighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

-- Use Tree-sitter highlighting when Neovim can load a parser for the filetype.
local treesitter_group = group("CpTreesitter", { clear = true })
autocmd("FileType", {
  group = treesitter_group,
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype
    if filetype == "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(filetype)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(event.buf, lang)
    end
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
local help_group = group("CpHelpVertical", { clear = true })
autocmd("FileType", {
  group = help_group,
  pattern = "help",
  callback = function()
    vim.cmd.wincmd("L")
  end,
})
