local has_tabnine, tabnine = pcall(require, "cmp_tabnine.config")
if not has_tabnine then
  print "tabnine"
  return
end
local has_lspkind, lspkind = pcall(require, "lspkind")
if not has_lspkind then
  print "lspkind"
  return
end
local has_cmd, cmp = pcall(require, "cmp")
if not has_cmd then
  print "cmp"
  return
end

tabnine:setup {
  max_lines = 1000,
  max_num_results = 3,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
  ignored_file_types = {
    sql = true,
    scala = true,
  },
}

cmp.setup {
  snippet = {
    expand = function(args)
      local luasnip = require "luasnip"
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-2),
    ["<C-f>"] = cmp.mapping.scroll_docs(2),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = false },
  },
  sources = cmp.config.sources({
    { name = "cmp_tabnine" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(_, vim_item)
      vim_item.menu = vim_item.kind
      vim_item.kind = lspkind.presets.default[vim_item.kind]

      return vim_item
    end,
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
}

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "cmdline" },
  },
})
