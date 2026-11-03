# Neovim configuration

A focused Neovim 0.12+ setup for editing, search, and LSP, managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Debuggers, Git porcelain UIs, message overhauls, and terminal multiplexing are intentionally left to external tools.

Leader is `<Space>`. Press it and wait for which-key to list the available bindings.

## Quick start

You need Neovim 0.12+, `git`, and `make`. For Tree-sitter parsers you also need the `tree-sitter` CLI, a C compiler, `tar`, and `curl`; without the CLI, parser installation is skipped.

```bash
make nvim            # from the repository root
DRY_RUN=1 make nvim  # preview first, if you like
```

This links `~/.config/nvim` to this directory. An existing `~/.config/nvim` is moved aside to `~/.config/nvim.bak-<timestamp>`. Because it is a symlink, edits here apply the next time Neovim starts, and the repository must stay where it is.

On first launch lazy.nvim installs itself and every plugin. Language servers are installed through Mason the first time you open a file; check them with `:Mason`.

## Files and windows

The explorer is the built-in netrw, opened on the left as a tree.

| Keys | Action |
|---|---|
| `<leader>e` | Toggle the explorer |
| `Ctrl-h/j/k/l` | Move between windows, including in and out of the explorer |
| `<leader>ff` / `<leader>fg` | Find files / live grep (Telescope) |
| `<leader>fb` / `<leader>fh` | Pick an open buffer / search help |

Inside the explorer, `Enter` opens a file in the file window, `gn` makes the directory under the cursor the tree root, `-` goes up, and `cd` sets Neovim's working directory there.

## Buffers and tabs

Open buffers are shown in the tabline at the top.

| Keys | Action |
|---|---|
| `]b` / `[b` | Next / previous buffer (built-in) |
| `<leader>bn` / `<leader>bp` | Next / previous buffer |
| `<leader><leader>` | Switch to the alternate buffer |
| `<leader>bd` | Delete the current buffer |
| `:q` | Close the current buffer while others are open; quit on the last one |
| `<leader>1` … `<leader>4` | Go to tab 1–4 |

## Editing

| Keys | Action |
|---|---|
| `gc` / `gcc` | Toggle comment on a selection / line (built-in) |
| `ys` / `ds` / `cs` | Add / delete / change surrounding pairs (nvim-surround) |
| `s` | Jump anywhere on screen (flash) |
| `S` | Select a syntax node (flash, needs a Tree-sitter parser) |
| `<leader>h` | Clear search highlight |
| `<leader>tn` | Toggle relative line numbers |

Brackets and quotes close automatically (nvim-autopairs), and other occurrences of the word under the cursor are highlighted (vim-illuminate).

Defaults worth knowing: the system clipboard is used for yank and paste, undo history persists across sessions, the cursor returns to its last position when a file is reopened, and no swap or backup files are written. Indentation is 2 spaces, or real tabs of width 4 for Go, Make, and Protobuf.

### Completion and snippets

Completion (blink.cmp) opens as you type in insert mode and draws on LSP, file paths, snippets from friendly-snippets, and words in open buffers.

| Keys | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item, or jump between snippet fields |
| `<CR>` | Accept the selected item, or the first one |
| `<C-Space>` | Open the menu |
| `<C-b>` / `<C-f>` | Scroll the documentation window |

## Code intelligence

### Language servers

`lua_ls`, `pyright`, `ruff`, `ts_ls`, `jsonls`, and `yamlls` are installed through Mason and start automatically; `gopls` is added when Go is installed. Formatting comes from the servers themselves: Ruff formats Python (its hover is turned off so Pyright's is shown).

| Keys | Action |
|---|---|
| `gd` / `K` | Go to definition / hover documentation |
| `grr` / `gri` | References / implementation (built-in) |
| `<leader>rn` or `grn` | Rename symbol |
| `<leader>ca` or `gra` | Code action |
| `<leader>lf` | Format the buffer, when the server supports it |
| `<leader>o` | Toggle the symbol outline (aerial) |

### Diagnostics

| Keys | Action |
|---|---|
| `[d` / `]d` | Previous / next diagnostic, with details in a float |
| `<leader>ld` | Show the diagnostic under the cursor |
| `<leader>lq` / `<leader>ll` | Send diagnostics to the location list / quickfix list |

Git changes are marked in the sign column by gitsigns.

### Syntax highlighting

nvim-treesitter (`main` branch) installs parsers for Python, JavaScript, TypeScript, TSX, Go, JSON, YAML, Bash, TOML, HTML, and CSS on startup. Neovim also ships parsers for C, Lua, Vimscript, Vim help, Markdown, and Tree-sitter queries. Any filetype with a parser gets Tree-sitter highlighting; the rest fall back to regular syntax highlighting.

## Maintaining the config

### Updating plugins

`:Lazy update` writes straight to `nvim/lazy-lock.json` in this repository, so changes show up in Git:

```bash
git diff nvim/lazy-lock.json
git commit -m 'Update Neovim plugin lockfile' nvim/lazy-lock.json
# or discard: git checkout -- nvim/lazy-lock.json, then :Lazy restore
```

Use `:Lazy sync` after adding or removing a plugin spec, and `:Lazy clean` to delete plugins that are no longer listed. lazy.nvim also checks for updates once a day.

### Where things live

```
init.lua              sets leaders, loads core modules, then lazy.nvim
lua/core/             plugin-independent settings
  options.lua           editor options and netrw settings
  keymaps.lua           key bindings and the smart :q
  autocmds.lua          netrw navigation, Tree-sitter start, yank highlight, per-filetype tweaks
lua/config/lazy.lua   lazy.nvim bootstrap and options; imports lua/plugins/
lua/plugins/          plugin specs: ui, editor, search, git, lsp, completion, treesitter
tests/                headless checks used by the test scripts
lazy-lock.json        pinned plugin commits
stylua.toml           Lua formatting rules
```

- **Add a plugin:** put its spec in the matching file under `lua/plugins/`, keeping its `keys`, `opts`, or `config` with it.
- **Add a language server:** add it to the `servers` table in `lua/plugins/lsp.lua`, then add it to the list in `tests/lsp.lua`.
- **Add a parser:** add it to the list in `lua/plugins/treesitter.lua`.
- **Change options or plugin-independent keys:** edit `lua/core/`, which the core test loads without any plugins.

### Testing

| Command | Checks | Needs network |
|---|---|---|
| `./scripts/test-nvim-core.sh` | Core modules load; explorer window navigation | No |
| `make nvim-test` | Stylua, full headless `Lazy! sync`, every plugin loads, LSP servers enabled | Yes |

`make nvim-test` uses isolated directories under `.cache/nvim-test/` and never touches your own Neovim data. Set `SKIP_STYLUA=1` to skip the format check.

### CI

GitHub Actions (`.github/workflows/nvim.yml`) and GitLab CI (`.gitlab-ci.yml`) run Stylua and the core test on pushes and pull or merge requests that touch the config. A separate plugin sync job runs weekly or on demand.

For GitLab, create the weekly schedule under **Build > Pipeline schedules** with cron `17 3 * * 1` (UTC) on the default branch, and trigger a manual run from **Build > Pipelines > New pipeline**.
