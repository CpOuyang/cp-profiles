SHELL := /bin/bash

DRY_RUN ?= 0
DRY_COND = [ -n "$(DRY_RUN)" ] && [ "$(DRY_RUN)" != "0" ]

CLEAN_TOP_LEVEL := node_modules build dist out tmp temp coverage .cache .venv venv ENV env target logs
CLEAN_DIR_PATTERNS := __pycache__ .pytest_cache .mypy_cache .ruff_cache .cache
CLEAN_FILE_PATTERNS := *~ .DS_Store *.pyc *.log Thumbs.db .project .coverage *.coverage coverage.xml *.swp *.swo

.PHONY: help clean bash zsh fish alacritty kitty tmux python starship nvim nvim-clean homebrew

help: ## 列出可用指令與說明
	@printf 'make targets:\n'
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-18s %s\n", $$1, $$2}'
	@printf '\n可在前綴加上 DRY_RUN=1 預覽動作，例如 DRY_RUN=1 make bash\n'
	@printf '若只想同步檔案可加 SKIP_BREW=1，避免重複執行 brew。\n'

clean: ## 清除常見建置與快取資料夾
	@echo "==> Removing common build/venv directories"
	@for dir in $(CLEAN_TOP_LEVEL); do \
		if [ -e "$$dir" ]; then \
			if $(DRY_COND); then \
				echo "[dry-run] rm -rf $$dir"; \
			else \
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
	@echo "==> Removing cached files"
	@set -f; \
	for pattern in $(CLEAN_FILE_PATTERNS); do \
		if $(DRY_COND); then \
			echo "[dry-run] find . -type f -name $$pattern -delete"; \
		else \
			find . -type f -name "$$pattern" -delete; \
		fi; \
	done
	@echo "==> Clean complete"

homebrew: ## 檢查 Homebrew 並安裝預設套件
	@DRY_RUN=$(DRY_RUN) ./scripts/setup-homebrew.sh

# --- Shell profiles ---------------------------------------------------------

bash: ## 同步 Bash 設定到 ~/.bash_profile，並安裝常用 CLI
	@$(MAKE) --no-print-directory homebrew
	@if $(DRY_COND); then \
		echo "[dry-run] install bash/bash_profile -> ~/.bash_profile"; \
	else \
		install -m 0644 bash/bash_profile ~/.bash_profile; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] ./scripts/ensure-bash-local.sh"; \
	else \
		./scripts/ensure-bash-local.sh; \
	fi

zsh: ## 同步 Zsh 設定到 ~/.zshrc
	@if $(DRY_COND); then \
		echo "[dry-run] install zsh/zshrc -> ~/.zshrc"; \
	else \
		install -m 0644 zsh/zshrc ~/.zshrc; \
	fi

fish: ## 同步 Fish 設定到 ~/.config/fish/config.fish
	@if $(DRY_COND); then \
		echo "[dry-run] install -d ~/.config/fish"; \
	else \
		install -d ~/.config/fish; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] install fish/config.fish -> ~/.config/fish/config.fish"; \
	else \
		install -m 0644 fish/config.fish ~/.config/fish/config.fish; \
	fi

# --- Terminal configs ------------------------------------------------------

alacritty: ## 安裝 Alacritty (Homebrew cask) 並同步設定
	@DRY_RUN=$(DRY_RUN) BREW_FORMULAS="" BREW_CASKS="alacritty" ./scripts/setup-homebrew.sh
	@dest="$$HOME/.config/alacritty"; \
	if $(DRY_COND); then \
		echo "[dry-run] rm -rf $$dest"; \
		echo "[dry-run] install -d $$HOME/.config"; \
		echo "[dry-run] cp -R alacritty $$dest"; \
	else \
		rm -rf "$$dest"; \
		install -d "$$HOME/.config"; \
		cp -R alacritty "$$dest"; \
	fi

kitty: ## 安裝 Kitty (Homebrew cask) 並同步設定
	@DRY_RUN=$(DRY_RUN) BREW_FORMULAS="" BREW_CASKS="kitty" ./scripts/setup-homebrew.sh
	@dest="$$HOME/.config/kitty"; \
	if $(DRY_COND); then \
		echo "[dry-run] rm -rf $$dest"; \
		echo "[dry-run] install -d $$HOME/.config"; \
		echo "[dry-run] cp -R kitty $$dest"; \
	else \
		rm -rf "$$dest"; \
		install -d "$$HOME/.config"; \
		cp -R kitty "$$dest"; \
	fi

# --- Prompt / tmux ---------------------------------------------------------

tmux: ## 安裝 tmux 並同步 ~/.tmux.conf
	@DRY_RUN=$(DRY_RUN) BREW_FORMULAS="tmux" ./scripts/setup-homebrew.sh
	@if $(DRY_COND); then \
		echo "[dry-run] install tmux/tmux.conf -> ~/.tmux.conf"; \
	else \
		install -m 0644 tmux/tmux.conf ~/.tmux.conf; \
	fi

starship: ## 同步 Starship 主題到 ~/.config/starship.toml
	@if $(DRY_COND); then \
		echo "[dry-run] install -d ~/.config"; \
	else \
		install -d ~/.config; \
	fi
	@if $(DRY_COND); then \
		echo "[dry-run] install starship/starship.toml -> ~/.config/starship.toml"; \
	else \
		install -m 0644 starship/starship.toml ~/.config/starship.toml; \
	fi

# --- Editors / languages ---------------------------------------------------

nvim: ## 同步 Neovim 設定到 ~/.config/nvim
	@dest="$$HOME/.config/nvim"; backup="$$dest.bak-$$(date +%Y%m%d%H%M%S)"; \
	if $(DRY_COND); then \
		echo "[dry-run] (if exists) mv $$dest $$backup"; \
		echo "[dry-run] rm -rf $$dest"; \
		echo "[dry-run] install -d $$dest"; \
		echo "[dry-run] cp -R nvim/. $$dest"; \
	else \
		if [ -d "$$dest" ] || [ -f "$$dest" ]; then \
			echo "Backing up existing Neovim config to $$backup"; \
			mv "$$dest" "$$backup"; \
		fi; \
		install -d "$$dest"; \
		cp -R nvim/. "$$dest"; \
	fi

nvim-clean: ## 移除 ~/.config/nvim 方便重新同步
	@if $(DRY_COND); then \
		echo "[dry-run] rm -rf ~/.config/nvim"; \
	else \
		rm -rf ~/.config/nvim; \
	fi

python: ## 安裝指定位 Python 版本並同步 Poetry 設定/專案
	@DRY_RUN=$(DRY_RUN) ./scripts/setup-python.sh
