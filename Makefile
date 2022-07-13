.PHONY: clean nvim bash

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

nvim:
	rm -rf ~/.config/nvim/
	cp -r nvim/ ~/.config/nvim/

bash:
	cp .bash_profile ~/
