.PHONY: clean bash nvchad nvim starship

help:
	@echo "make"
	@echo "    help"
	@echo "        Show the basic help."
	@echo "    clean"
	@echo "        Cleanse."
	@echo "    bash"
	@echo "        Bash shell."
	@echo "    nvim"
	@echo "        neovim editor."
	@echo "    starship"
	@echo "        Starship shell prompt."

clean:
	find . -name '*~' -exec rm -f  {} +
	find . -name '.DS_Store' -exec rm -f  {} +

bash:
	cp .bash_profile ~/

nvchad:
	rm -rf ~/.config/nvim/
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

nvim:
	rm -rf ~/.config/nvim/
	cp -r nvim/ ~/.config/nvim/

starship:
	cp starship.toml ~/.config/
