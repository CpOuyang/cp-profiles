# CP Profiles

在 macOS 上快速建置終端與開發環境的設定集，所有檔案集中管理，換機或回復時只需幾個 `make` 指令即可完成。

## 目標
- 所有終端／編輯器／語言工具設定集中管理，避免分散的 dotfiles
- 保留 macOS 專屬調整，同時讓跨機器共用的設定容易同步
- 透過 Makefile 自動化同步與安裝流程，確保部署可預期

## 結構
- `bash/`：Bash 登入設定與覆寫範本。
- `zsh/`：Zsh 設定，內容與 Bash 對齊。
- `fish/`：Fish shell 設定，維持一致的環境與別名。
- `tmux/`：tmux 配置，統一快捷鍵與狀態列。
- `alacritty/`：Alacritty 終端設定，對應 `~/.config/alacritty/`。
- `kitty/`：Kitty 終端設定，對應 `~/.config/kitty/`。
- `nvim/`：Neovim Lua 設定與外掛管理。
- `python/`：pyenv 版本清單、Poetry 預設值與專案列表。
- `nodejs/`：預留的 Node.js 版本／工具鏈設定。
- `starship/`：Starship 提示字串主題。
- `scripts/`：部署與自動化腳本。
- `Makefile`：集中管理同步與安裝指令。
- `.reference/`：歷史或實驗設定的歸檔區。

## 待辦規劃
- `nvim/`：補齊 Lua 模組說明、外掛測試流程與 CI 檢查
- `vscode/`：收錄設定檔、鍵盤配置與 snippets
- `python/`：預設安裝更多常用 Python 版本 / 套件
- `nodejs/`：新增版本管理與常用全域工具建議

## 前置需求
- macOS（主要開發環境）以及 [Homebrew](https://brew.sh/)；若使用 Linux 或無法安裝 Homebrew，可在執行指令時帶上 `SKIP_BREW=1` 並手動安裝所需套件。
- 基本開發工具：`git`、`curl`、`pyenv`、`poetry`。缺少時腳本會給出安裝連結。
- 建議事先安裝常用字型（例如 Nerd Font）以確保終端顯示正常。

## 使用方式
1. 先檢視資料夾內容，把與機器相關的私人資訊（token、路徑等）改寫到 `*.local` 類別的忽略檔。
2. 執行 `make help` 快速查看可用 target 與說明。
3. `make python`：安裝 `python/versions.txt` 列出的 pyenv 版本、套用 Poetry 預設值並同步清單中的專案（需先安裝 pyenv、Poetry）。
4. `make bash|zsh|fish`：同步對應 shell 設定；Bash 版會自動建立 `~/.bash_profile.local`。`make bash` 會額外安裝常用 CLI（starship、fzf、ripgrep）。
5. `make tmux`：安裝 tmux 並複製設定至 `~/.tmux.conf`。
6. `make nvim`：同步 Neovim 設定到 `~/.config/nvim/`；第一次啟動建議執行 `:Lazy sync`、`:MasonInstall stylua prettier shfmt black`。
7. `make alacritty|kitty` 與 `make starship`：安裝終端應用程式（透過 Homebrew cask）並複製對應設定。
8. 需要預覽時可在前面加上 `DRY_RUN=1`，例如 `DRY_RUN=1 make tmux`，指令只會印出動作不寫入檔案。可搭配 `SKIP_BREW=1` 加速純檔案同步，或先執行 `make homebrew` 單獨檢查套件。

## 注意事項
- 目前僅針對 macOS 設計，其他作業系統暫不支援。
- `make python` 需要事先安裝 `pyenv` 與 `poetry`（可透過 Homebrew 或官方安裝程式）。
- 機器專屬的環境變數或密鑰建議放在 `~/.bash_profile.local` 等忽略檔案中，Bash 版設定會自動載入。
- `scripts/ensure-bash-local.sh` 會在必要時建立 `~/.bash_profile.local`，其他 shell 可依需求新增對應流程。
- `scripts/setup-homebrew.sh` 會在 shell / tmux / 終端 target 中呼叫；若偵測到非 macOS 會自動跳過，請自行安裝套件或帶上 `SKIP_BREW=0` 使用 Linuxbrew。預設清單可透過 `BREW_FORMULAS`、`BREW_CASKS` 覆寫，或以 `SKIP_BREW=1` 單純同步檔案。
- 記得將 `.venv/` 等虛擬環境與暫存檔維持在 `.gitignore` 中，以免誤入版本庫。
- `.reference/` 只做為實驗與備份，真正上線的設定請移到上述正式結構中。
- LLM 協作紀錄：
  - 2025-09：Codex（基於 GPT-5）協助撰寫 README 與自動化腳本。
