local _M = {}

_M.init = function()
  local ok, catppuccin = pcall(require, "catppuccin")
  if not ok then
    return
  end
  catppuccin.setup {
    integrations = {
      bufferline = false,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = "NONE",
          hints = "NONE",
          warnings = "NONE",
          information = "NONE",
        },
        underlines = {
          errors = "underline",
          hints = "underline",
          warnings = "underline",
          information = "underline",
        },
      },
    },
  }
  vim.g.catppuccin_flavour = "mocha"
  vim.cmd [[colorscheme catppuccin]]
end

return _M
