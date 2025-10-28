local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local powerline = require("theme").powerline.circle
local theme = require("theme").theme

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local config = {
  options = {
    globalstatus = true,
    component_separators = "",
    section_separators = { left = powerline.right, right = powerline.left },
    theme = theme,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = {
      { "filetype", fmt = string.upper, icons_enabled = true },
      { "filename", cond = conditions.buffer_not_empty },
      { "location", icon = "" },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      },
    },
    lualine_x = {
      {
        function()
          local msg = "No Active Lsp"
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end

          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes

            if client.name ~= "null-ls" and filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = "",
        cond = conditions.buffer_not_empty,
      },
      {
        "o:encoding",
        fmt = string.upper,
        cond = conditions.buffer_not_empty,
      },
      {
        "fileformat",
        fmt = string.upper,
        cond = conditions.buffer_not_empty,
        icons_enabled = true,
      },
      {
        function()
          return vim.opt.tabstop:get()
        end,
        icon = "הּ",
        cond = conditions.buffer_not_empty,
      },
    },
    lualine_y = {
      {
        "branch",
        icon = "",
        cond = conditions.check_git_workspace,
        separator = { left = powerline.left },
      },
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
      },
    },
    lualine_z = {},
  },
}

lualine.setup(config)
