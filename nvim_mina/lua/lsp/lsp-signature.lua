local status_ok, signature = pcall(require, "lsp_signature")
if not status_ok then
  return
end

local M = {}
M.setup = function()
  local cfg = {
    bind = true,
    hint_enable = false,
    handler_opts = {
      border = "rounded",
    },
  }
  signature.setup(cfg)
  signature.on_attach(cfg, bufnr)
end

return M
