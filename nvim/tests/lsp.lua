for _, server in ipairs({ "lua_ls", "pyright", "ruff", "ts_ls", "jsonls", "yamlls" }) do
  assert(vim.lsp.config[server], server .. " has no LSP configuration")
  assert(vim.lsp.is_enabled(server), server .. " is not enabled")
end
