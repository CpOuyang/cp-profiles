local opt = vim.opt
local g = vim.g

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.clipboard = "unnamedplus"
opt.fileencoding = "utf-8"
opt.mouse = "a"
opt.cursorline = true

opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.signcolumn = "yes"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.breakindent = true
opt.linebreak = true
opt.showmode = false
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.termguicolors = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }

opt.list = true
opt.listchars = { tab = "» ", trail = "·", extends = "…", precedes = "…" }

opt.undofile = true

opt.fillchars = { eob = " " }
opt.shortmess:append("c")

g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
