# Kickstart init.lua of neovim from https://github.com/nvim-lua/kickstart.nvim

curl -s https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua -o ./init.lua

echo $'\r' >> ./init.lua
echo "vim.opt.clipboard = 'unnamedplus'" >> ./init.lua
