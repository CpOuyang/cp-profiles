local M = {}

local lua_dev = require("lua-dev").setup {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    settings = lua_dev.settings,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
