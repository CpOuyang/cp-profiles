local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  }
end

return M
