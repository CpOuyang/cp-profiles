local config = vim.env.NVIM_TEST_CONFIG

-- Keep the built-in explorer test independent of clipboard tools and user history.
vim.opt.clipboard = ""
vim.g.netrw_dirhistmax = 0
vim.cmd.packadd("netrw")
vim.cmd.edit(vim.fn.fnameescape(config .. "/init.lua"))

local file_win = vim.api.nvim_get_current_win()
local file_buf = vim.api.nvim_get_current_buf()

local function press(keys)
  vim.cmd.normal(vim.api.nvim_replace_termcodes(keys, true, false, true))
end

local function check_navigation()
  assert(#vim.api.nvim_tabpage_list_wins(0) == 2, "Expected one explorer and one file window")
  local explorer_win = vim.api.nvim_get_current_win()
  local explorer_buf = vim.api.nvim_get_current_buf()
  assert(vim.bo[explorer_buf].filetype == "netrw", "Expected the explorer to have focus")
  local buffer_count = #vim.api.nvim_list_bufs()

  for _ = 1, 3 do
    press("<C-l>")
    assert(vim.api.nvim_get_current_win() == file_win, "Ctrl-l must return to the file window")
    assert(vim.api.nvim_get_current_buf() == file_buf, "Ctrl-l must preserve the edited file")
    press("<C-h>")
    assert(
      vim.api.nvim_get_current_win() == explorer_win,
      "Ctrl-h must focus the existing explorer"
    )
    assert(
      vim.api.nvim_get_current_buf() == explorer_buf,
      "Ctrl-h must preserve the explorer buffer"
    )
  end

  assert(#vim.api.nvim_tabpage_list_wins(0) == 2, "Navigation must not create windows")
  assert(#vim.api.nvim_list_tabpages() == 1, "Navigation must not create tabs")
  assert(#vim.api.nvim_list_bufs() == buffer_count, "Navigation must not create buffers")

  press("<C-h>")
  assert(
    vim.api.nvim_get_current_win() == explorer_win,
    "Ctrl-h at the left edge must stay in the explorer"
  )
end

vim.cmd.Lexplore(vim.fn.fnameescape(config))
check_navigation()

-- Expanding a directory rebuilds netrw's mappings.
assert(vim.fn.search("\\Vlua/\\m$", "w") > 0, "Expected the lua directory in the explorer")
press("<CR>")
check_navigation()

-- Closing and reopening the explorer must retain the same navigation behavior.
press("<C-l>")
vim.cmd.Lexplore()
assert(#vim.api.nvim_tabpage_list_wins(0) == 1, "Expected the explorer to close")
vim.cmd.Lexplore(vim.fn.fnameescape(config))
check_navigation()

local explorer_win = vim.api.nvim_get_current_win()
vim.cmd("CpSmartQuit")
assert(not vim.api.nvim_win_is_valid(explorer_win), "Smart quit must close the explorer window")
assert(#vim.api.nvim_tabpage_list_wins(0) == 1, "Smart quit must leave the file window open")
assert(vim.api.nvim_get_current_win() == file_win, "Smart quit must focus the file window")
assert(vim.api.nvim_win_get_buf(file_win) == file_buf, "Smart quit must preserve the file buffer")
assert(vim.api.nvim_buf_is_loaded(file_buf), "Smart quit must keep the file buffer loaded")
assert(vim.bo[file_buf].buflisted, "Smart quit must keep the file buffer listed")
