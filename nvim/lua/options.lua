local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 1,
	completeopt = { "menuone", "noselect" },
	cursorline = true,
	expandtab = true,
	fileencoding = "utf-8",
	foldlevelstart = 20,
	foldmethod = "indent",
	foldnestmax = 20,
	hlsearch = true,
	laststatus = 3,
	mouse = "a",
	number = true,
	numberwidth = 4,
	pumheight = 10,
	shiftwidth = 4,
	showmode = false,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 4,
	termguicolors = true,
	updatetime = 250, -- for lsp
  }
  
  vim.opt.fillchars.eob = " "
  vim.opt.shortmess:append "c" -- for nvim-metals
  
  for k, v in pairs(options) do
	vim.opt[k] = v
  end
  
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
  