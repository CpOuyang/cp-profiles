local status_ok, installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local M = {}
M.setup = function(servers)
  installer.setup {
    ensure_installed = servers,
    automatic_installation = true,
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  }
end

return M
