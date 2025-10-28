local ok, toggleterm = pcall(require, "toggleterm")

if not ok then
  return
end

toggleterm.setup {
  open_mapping = [[<c-t>]],
  direction = "float",
  float_opts = {
    border = "curved",
    winblend = 0,
  },
}

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new { cmd = "lazygit", hidden = true }

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end
