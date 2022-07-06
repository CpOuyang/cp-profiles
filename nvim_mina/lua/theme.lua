local _M = {}

_M.theme = "catppuccin"

_M.powerline = {
  circle = {
    left = "",
    right = "",
  },
  arrow = {
    left = "",
    right = "",
  },
  triangle = {
    left = "",
    right = "",
  },
  none = {
    left = "",
    right = "",
  },
}

_M.signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }

_M.init = function()
  require("themes." .. _M.theme).init()
end

return _M
