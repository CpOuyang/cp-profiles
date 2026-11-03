# CP Profiles

在 macOS 上建置終端與開發環境的設定集。shell、終端機、編輯器與語言工具的設定都集中在這個 repo，換機或還原時用幾個 `make` 指令即可部署。

- 所有設定集中管理，不再散落各處的 dotfiles。
- 保留 macOS 專屬調整，同時讓跨機器共用的部分容易同步。
- 部署流程由 Makefile 統一處理，可先預覽、會備份既有設定，結果可預期。

## 快速開始

**前置需求**

- macOS 與 [Homebrew](https://brew.sh/)
- `git`、`curl`
- `make python` 另需 `pyenv` 與 `poetry`
- 建議字型：Maple Mono Normal NF CN（終端機相關指令會自動檢查，缺少時透過 Homebrew 安裝 `font-maple-mono-nerd-font`）

**新機器建議順序**

```bash
make help              # 列出所有指令
DRY_RUN=1 make bash    # 任何指令都可以先預覽，不會寫入檔案

make bash              # Bash 設定，並安裝 starship、fzf、ripgrep
make tmux
make kitty             # 或 alacritty、iterm2
make nvim
make python
```

部署前請先把機器專屬的內容（token、私人路徑等）移到 `*.local` 檔案，見[機器專屬設定](#機器專屬設定)。

## 元件一覽

| 目錄 | 指令 | 部署到 | 既有設定的處理 | 說明 |
|---|---|---|---|---|
| `bash/` | `make bash` | `~/.bash_profile` | 內容不同時先備份 | 會一併執行 `make homebrew`、`make starship`，並建立 `~/.bash_profile.local` |
| `zsh/` | `make zsh` | `~/.zshrc` | 內容不同時先備份 | 內容與 Bash 版對齊 |
| `fish/` | `make fish` | `~/.config/fish/config.fish` | 內容不同時先備份 | |
| `starship/` | `make starship` | `~/.config/starship.toml` | 內容不同時先備份 | 「霧夜藍」單行 Powerline 主題，需 Nerd Font；只同步主題，starship 本身由 `make bash` 安裝 |
| `tmux/` | `make tmux` | `~/.tmux.conf` | 內容不同時先備份 | 會透過 Homebrew 安裝 tmux |
| `alacritty/` | `make alacritty` | `~/.config/alacritty/` | 內容不同時先整個目錄備份 | 會透過 Homebrew cask 安裝 Alacritty |
| `kitty/` | `make kitty` | `~/.config/kitty/` | 內容不同時先整個目錄備份 | 會透過 Homebrew cask 安裝 Kitty；[主題說明](kitty/README.md) |
| `iterm2/` | `make iterm2` | iTerm2 的 `DynamicProfiles/cp-profiles.json` | 覆蓋同名檔案 | 會透過 Homebrew cask 安裝 iTerm2；[啟用方式](iterm2/README.md) |
| `nvim/` | `make nvim` | `~/.config/nvim`（symlink） | 整個目錄先備份 | 設定修改直接生效，repo 請勿移動；[完整說明](nvim/README.md) |
| `python/` | `make python` | pyenv、Poetry | — | 安裝 `versions.txt` 的 Python 版本、套用 `poetry.toml`、同步 `projects.txt` 的專案 |
| `nodejs/` | — | — | — | 預留，尚未有部署指令 |
| `agents/` | `make agents PROJECT_DIR=…` | 指定專案 | 已存在時停止，`FORCE=1` 才覆蓋 | Claude 規劃、Codex 執行的 AI 協作流程；[說明](agents/README.md) |

除了 `nvim` 是 symlink，其他元件都是**複製**部署：修改 repo 後要重新執行對應指令才會生效。備份放在原檔旁，名稱為 `<原名稱>.bak-*`。

## 通用選項

可加在任何 `make` 指令前面，例如 `DRY_RUN=1 SKIP_BREW=1 make kitty`。

| 選項 | 作用 |
|---|---|
| `DRY_RUN=1` | 只印出會執行的動作，不寫入任何檔案 |
| `SKIP_BREW=1` | 略過 Homebrew 安裝，只同步設定檔 |
| `BREW_FORMULAS`、`BREW_CASKS` | 覆寫 `make homebrew` 預設安裝的套件清單（預設 formula 為 starship、fzf、ripgrep） |
| `FORCE=1` | `make agents` 在目標專案已有 `AGENTS.md` 或 `agents/` 時仍覆蓋 |
| `PROJECT_DIR=…` | `make agents` 的目標專案路徑 |

其他指令：

- `make homebrew`：單獨檢查 Homebrew 並安裝預設套件。非 macOS 會自動略過。
- `make clean`：清除 repo 內的建置產物與快取，例如 `.venv/`、`node_modules/`、`__pycache__/`、`.cache/`、`.DS_Store`。

## 機器專屬設定

不要把 token、密鑰或只屬於某台機器的路徑寫進 repo，改放在不受版本控制的 `*.local` 檔案：

- Bash 會自動載入 `~/.bash_profile.local` 與 `~/.bashrc.local`；`make bash` 會在檔案不存在時建立 `~/.bash_profile.local`。
- Zsh 與 Fish 目前沒有對應的 `.local` 載入機制，需要時請自行加入。

`.venv/`、`.env` 等虛擬環境與環境變數檔已列在 `.gitignore`，新增類似檔案時請一併確認。

## 維護與驗證

- **Neovim 測試**：`make nvim-test` 會檢查 Lua 格式、在隔離目錄同步並載入所有外掛；GitHub Actions 與 GitLab CI 會在 Neovim 設定變動時自動執行核心測試。細節見 [nvim/README.md](nvim/README.md#testing)。
- **AI 協作**：本 repo 使用 Claude 規劃、Codex 執行、使用者決策的流程，入口是 [`AGENTS.md`](AGENTS.md)，完整規則在 [`agents/`](agents/README.md)。
- **歸檔**：`.reference/` 只放歷史或實驗用設定，正式使用的設定請移到上方對應目錄。
- **支援範圍**：目前只針對 macOS。Linux 可以用 `SKIP_BREW=1` 同步設定檔並自行安裝套件，但沒有經過測試。

## 待辦

- `vscode/`：收錄設定檔、鍵盤配置與 snippets。
- `python/`：預設安裝更多常用 Python 版本與套件。
- `nodejs/`：加入版本管理與常用全域工具。
