.PHONY: clean nvim bash starship

help:
	@echo "make"
	@echo "    help"
	@echo "        Show the basic help."
	@echo "    clean"
	@echo "        Cleanse."

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	find . -name '.DS_Store' -exec rm -f  {} +
	find . -name '__pycache__' -type d -exec rm -rf  {} +
	find . -name '.pytest_cache' -type d -exec rm -rf  {} +

bash:
	cp .bash_profile ~/

nvim:
	rm -rf ~/.config/nvim/
	cp -r nvim/ ~/.config/nvim/

starship:
	cp .starship.toml ~//config/
