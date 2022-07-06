local servers = {
  "clangd",
  "gopls",
  "jsonls",
  "null-ls",
  "pyright",
  "sumneko_lua",
  "vim-metals",
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local opts = { noremap = true, silent = true, nowait = true }

vim.api.nvim_set_keymap("n", "<C-[>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-]>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>cf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

  if client.supports_method "textDocument/formatting" then
    if client.name ~= "null-ls" then
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end

    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.formatting_sync(nil, 2000)
      end,
    })
  end
end

local has_installer, installer = pcall(require, "lsp.lsp-installer")
if has_installer then
  installer.setup(servers)
end

local has_signature, signature = pcall(require, "lsp.lsp-signature")
if has_signature then
  signature.setup()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

local has_lspconfig = pcall(require, "lspconfig")
if has_lspconfig then
  for _, server in ipairs(servers) do
    require("lsp.servers." .. server).setup(on_attach, capabilities)
  end
end

-- Gutter sign icons
local theme = require "theme"
for type, icon in pairs(theme.signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- use floating window for diagnostic
vim.diagnostic.config {
  virtual_text = false,
}
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local dopts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "single",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, dopts)
  end,
})
