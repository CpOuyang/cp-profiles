local function lsp_on_attach(client, bufnr)
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end

  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "K", vim.lsp.buf.hover, "Hover")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  if client.supports_method and client:supports_method("textDocument/formatting") then
    bufmap("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end
end

return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
      "MasonUpdateAll",
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      { "saghen/blink.cmp" },
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        pyright = {},
        ruff = {},
        ts_ls = {},
        jsonls = {},
        yamlls = {},
      }

      if vim.fn.executable("go") == 1 then
        servers.gopls = {}
      end

      local default_opts = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        on_attach = lsp_on_attach,
      }

      local server_names = vim.tbl_keys(servers)

      mason.setup()

      for server, server_opts in pairs(servers) do
        local opts = vim.tbl_deep_extend("force", {}, default_opts, server_opts)
        vim.lsp.config(server, opts)
      end

      mason_lspconfig.setup({ ensure_installed = server_names, automatic_enable = false })

      for server in pairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
