SHELL := /bin/bash

SHELL_PROFILES := bash zsh fish
TERMINAL_APPS := alacritty kitty
DRY_RUN ?= 0
DRY_COND = [ -n "$(DRY_RUN)" ] && [ "$(DRY_RUN)" != "0" ]

.PHONY: help clean shell shell-bash shell-zsh shell-fish terminal terminal-alacritty terminal-kitty bash bash-local zsh fish alacritty kitty starship

help: ## Show the basic help.
	@printf 'make targets:\n'
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'
	@printf '\nUse DRY_RUN=1 make <target> to preview actions without making changes.\n'
	@if $(DRY_COND); then printf '(dry-run mode active)\n'; fi

# Root-level directories that are safe to delete when cleaning the workspace
CLEAN_ROOT_DIRS := \
	node_modules \
	build \
	dist \
	out \
	tmp \
	temp \
	coverage \
	target \
	logs \
	.cache \
	.pytest_cache \
	.mypy_cache \
	.ruff_cache \
	.venv \
	venv \
	ENV \
	env \
	.idea \
	.vscode

# Directory patterns searched recursively and removed with find
CLEAN_DIR_PATTERNS := __pycache__ *.egg-info .pytest_cache .mypy_cache .ruff_cache .cache

# File patterns searched recursively and deleted with find
CLEAN_FILE_PATTERNS := *~ .DS_Store *.pyc *.log Thumbs.db .project .coverage *.coverage coverage.xml *.swp *.swo

clean: ## Remove generated files, caches, and build outputs.
	@echo "==> Removing top-level build and cache directories"
	@for dir in $(CLEAN_ROOT_DIRS); do \
		if [ -e "$$dir" ]; then \
			if $(DRY_COND); then \
				echo "[dry-run] rm -rf $$dir"; \
			else \
				echo "   rm -rf $$dir"; \
				rm -rf "$$dir"; \
			fi; \
		fi; \
	done
	@echo "==> Removing cached directories matching patterns"
	@set -f; \
	for pattern in $(CLEAN_DIR_PATTERNS); do \
		if $(DRY_COND); then \
			echo "[dry-run] find . -type d -name $$pattern -prune -exec rm -rf {} +"; \
		else \
			find . -type d -name "$$pattern" -prune -exec rm -rf {} +; \
		fi; \
	done
	@echo "==> Removing generated files matching patterns"
	@set -f; \
	for pattern in $(CLEAN_FILE_PATTERNS); do \
		if $(DRY_COND); then \
			echo "[dry-run] find . -type f -name $$pattern -delete"; \
		else \
			find . -type f -name "$$pattern" -delete; \
		fi; \
	done
	@echo "==> Clean complete"

bash:
	@:

zsh:
	@:

fish:
	@:

alacritty:
	@:

kitty:
	@:

shell: ## Sync a shell profile to the home directory. Usage: make shell <bash|zsh|fish>
	@profile="${PROFILE}"; \
	goals="$(MAKECMDGOALS)"; \
	if [ -z "$$profile" ]; then \
	  for goal in $$goals; do \
	    [ "$$goal" = "$@" ] && continue; \
	    for candidate in $(SHELL_PROFILES); do \
	      if [ "$$candidate" = "$$goal" ]; then \
	        profile="$$goal"; \
	        break 2; \
	      fi; \
	    done; \
	  done; \
	fi; \
	if [ -z "$$profile" ]; then \
	  echo "Usage: make shell <bash|zsh|fish>"; \
	  exit 2; \
	fi; \
	for candidate in $(SHELL_PROFILES); do \
	  if [ "$$candidate" = "$$profile" ]; then \
	    $(MAKE) --no-print-directory DRY_RUN=$(DRY_RUN) shell-$$profile; \
	    exit 0; \
	  fi; \
	done; \
	echo "Unknown shell profile: $$profile"; \
	exit 1

terminal: ## Sync a terminal profile to the home directory. Usage: make terminal <alacritty|kitty>
	@app="${APP}"; \
	goals="$(MAKECMDGOALS)"; \
	if [ -z "$$app" ]; then \
	  for goal in $$goals; do \
	    [ "$$goal" = "$@" ] && continue; \
	    for candidate in $(TERMINAL_APPS); do \
	      if [ "$$candidate" = "$$goal" ]; then \
	        app="$$goal"; \
	        break 2; \
	      fi; \
	    done; \
	  done; \
	fi; \
	if [ -z "$$app" ]; then \
	  echo "Usage: make terminal <alacritty|kitty>"; \
	  exit 2; \
	fi; \
	for candidate in $(TERMINAL_APPS); do \
	  if [ "$$candidate" = "$$app" ]; then \
	    $(MAKE) --no-print-directory DRY_RUN=$(DRY_RUN) terminal-$$app; \
	    exit 0; \
	  fi; \
	done; \
	echo "Unknown terminal profile: $$app"; \
	exit 1

shell-bash:
	@if $(DRY_COND); then \
		echo "[dry-run] install shell/bash_profile -> ~/.bash_profile"; \
	else \
		install -m 0644 shell/bash_profile ~/.bash_profile; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] ./scripts/ensure-bash-local.sh"; \
	else \
		./scripts/ensure-bash-local.sh; \
	fi

shell-zsh:
	@if $(DRY_COND); then \
		echo "[dry-run] install shell/zshrc -> ~/.zshrc"; \
	else \
		install -m 0644 shell/zshrc ~/.zshrc; \
	fi

shell-fish:
	@if $(DRY_COND); then \
		echo "[dry-run] install -d ~/.config/fish"; \
	else \
		install -d ~/.config/fish; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] install shell/config.fish -> ~/.config/fish/config.fish"; \
	else \
		install -m 0644 shell/config.fish ~/.config/fish/config.fish; \
	fi

terminal-alacritty:
	@dest="$$HOME/.config/alacritty"; \
	if $(DRY_COND); then \
		echo "[dry-run] rm -rf $$dest"; \
		echo "[dry-run] install -d $$HOME/.config"; \
		echo "[dry-run] cp -R terminal/alacritty $$dest"; \
	else \
		rm -rf "$$dest"; \
		install -d "$$HOME/.config"; \
		cp -R terminal/alacritty "$$dest"; \
	fi

terminal-kitty:
	@dest="$$HOME/.config/kitty"; \
	if $(DRY_COND); then \
		echo "[dry-run] rm -rf $$dest"; \
		echo "[dry-run] install -d $$HOME/.config"; \
		echo "[dry-run] cp -R terminal/kitty $$dest"; \
	else \
		rm -rf "$$dest"; \
		install -d "$$HOME/.config"; \
		cp -R terminal/kitty "$$dest"; \
	fi

bash-local:
	@if $(DRY_COND); then \
		echo "[dry-run] ./scripts/ensure-bash-local.sh"; \
	else \
		./scripts/ensure-bash-local.sh; \
	fi

starship: ## Copy starship.toml to ~/.config/.
	@if $(DRY_COND); then \
		echo "[dry-run] install -d ~/.config"; \
	else \
		install -d ~/.config; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] install starship.toml -> ~/.config/starship.toml"; \
	else \
		install -m 0644 starship.toml ~/.config/starship.toml; \
	fi
