# CP Profiles

開發適用於 macOS 上的個人工具集，並使用 Makefile 管理工作指令。

## 快速開始

**前置需求**

- 作業系統: macOS
- 管理工具: [Homebrew](https://brew.sh/)
  - `git`
  - `curl`
  - `pyenv`
  - `poetry`
  - `uv`
- 建議字型：Maple Mono Normal NF CN（`brew install font-maple-mono-nerd-font`）

**建議順序**

```bash
make help
DRY_RUN=1 make bash

make bash
make tmux
make kitty
make nvim
make python     # 尚未穩定開發
```

## 元件一覽

| 目錄 | 指令 | 部署位置 | 備註 |
|---|---|---|---|
| `bash/` | `make bash` | `~/.bash_profile` | 一併執行 `make homebrew`、`make starship` |
| `zsh/` | `make zsh` | `~/.zshrc` | 與 Bash 版對齊 |
| `fish/` | `make fish` | `~/.config/fish/config.fish` | |
| `starship/` | `make starship` | `~/.config/starship.toml` | 只同步主題，需 Nerd Font |
| `tmux/` | `make tmux` | `~/.tmux.conf` | |
| `alacritty/` | `make alacritty` | `~/.config/alacritty/` | |
| `kitty/` | `make kitty` | `~/.config/kitty/` | [說明](kitty/README.md) |
| `ghostty/` | `make ghostty` | `~/.config/ghostty/` | [說明](ghostty/README.md) |
| `iterm2/` | `make iterm2` | iTerm2 `DynamicProfiles/cp-profiles.json` | [說明](iterm2/README.md) |
| `nvim/` | `make nvim` | `~/.config/nvim`（symlink） | [說明](nvim/README.md) |
| `python/` | `make python` | pyenv、Poetry | 依 `versions.txt`、`poetry.toml`、`projects.txt` 安裝 |
| `nodejs/` | — | — | 預留 |
| `agents/` | `make agents PROJECT_DIR=…` | 指定專案 | [說明](agents/README.md) |

**部署規則**

- 除 `nvim` 為 symlink（修改即生效，repo 勿移動），其餘皆為複製，修改後需重新執行指令。
- 既有設定內容不同時備份為 `<原名稱>.bak-*`；`nvim` 一律備份，`iterm2` 直接覆蓋，`agents` 遇既有檔案即停止（`FORCE=1` 覆蓋）。
- `tmux`、`alacritty`、`kitty`、`ghostty`、`iterm2` 會透過 Homebrew 安裝對應程式。

## 選項與其他指令

| 選項 | 作用 |
|---|---|
| `DRY_RUN=1` | 只預覽，不寫入 |
| `SKIP_BREW=1` | 略過 Homebrew，只同步設定 |
| `BREW_FORMULAS`、`BREW_CASKS` | 覆寫 `make homebrew` 套件清單（預設 starship、fzf、ripgrep） |
| `FORCE=1` | `make agents` 強制覆蓋 |
| `PROJECT_DIR=…` | `make agents` 目標路徑 |

```bash
DRY_RUN=1 SKIP_BREW=1 make kitty   # 選項可組合
make homebrew                      # 安裝預設套件（非 macOS 略過）
make clean                         # 清除 .venv/、node_modules/、__pycache__/ 等快取
```

## Shell 設定

| Shell | 自動載入 |
|---|---|
| Bash | `~/.bash_profile.local`、`~/.bashrc.local` |
| Zsh | `~/.zshrc.local`、`~/.zshenv.local` |
| Fish | `~/.config/fish/local.fish` |

## 維護

- **測試**：`make nvim-test` 檢查 Lua 格式並載入所有外掛；CI 在 Neovim 設定變動時自動執行。見 [nvim/README.md](nvim/README.md#testing)。
- **AI 協作**：入口 [`AGENTS.md`](AGENTS.md)，規則見 [`agents/`](agents/README.md)。
- **支援範圍**：僅 macOS；Linux 可用 `SKIP_BREW=1` 同步設定（未測試）。

## 未來規劃

- `vscode/`：設定檔、鍵盤配置與 snippets
- `python/`：更多 Python 版本與套件
- `nodejs/`：版本管理與全域工具
