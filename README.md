# 3XANVIM

Personal Neovim config. Lua-only, `lazy.nvim` plugin manager, `mini.nvim`-centric.

## Structure

```
.
├── init.lua                    # Entry point → require("cxa")
├── stylua.toml                 # Lua formatter config
├── lua/
│   ├── cxa/
│   │   ├── init.lua            # Loads set, key, lsp modules
│   │   ├── lazy.lua            # Bootstraps lazy.nvim, loads plugin specs
│   │   ├── set.lua             # Editor options + colorscheme
│   │   ├── key.lua             # Keymaps
│   │   └── lsp.lua             # LSP server enablement
│   └── plugins/
│       ├── mini.lua            # mini.nvim spec
│       ├── treesitter.lua      # nvim-treesitter spec
│       ├── lsp-config.lua      # nvim-lspconfig spec
│       └── tmux.lua            # vim-tmux-navigator spec
└── after/plugin/
    ├── mini.lua                # mini.nvim module setup
    ├── mini-clue.lua           # mini.clue keymap hints
    └── treesitter.lua          # treesitter setup (currently disabled)
```

**Load order:** `init.lua` → `cxa/init.lua` → `cxa/lazy.lua` (bootstrap + plugins) → `cxa/set.lua` → `cxa/key.lua` → `cxa/lsp.lua` → `after/plugin/*.lua` (auto-sourced by Neovim after everything else).

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Modular plugin suite (see below) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting/parsing |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless tmux/vim pane navigation |

### mini.nvim modules in use

- `mini.comment` — commenting
- `mini.pairs` — auto-close brackets/quotes
- `mini.surround` — add/change/delete surroundings
- `mini.move` — move lines/selections
- `mini.starter` — start screen
- `mini.tabline` — tabline
- `mini.completion` — autocompletion
- `mini.indentscope` — indent scope guide (symbol: `¦`)
- `mini.statusline` — statusline (icons disabled)
- `mini.icons` — icon provider (ascii style)
- `mini.files` — file explorer (preview enabled, `<CR>` to enter dir)
- `mini.clue` — keymap hint popup

Colorscheme: `minisummer` (from mini.nvim), with `Normal`/`NonText` background cleared for terminal transparency. Falls back to `default` colorscheme if `minisummer` fails to load.

## LSP servers

Enabled via `vim.lsp.enable()` (Neovim 0.11+ native API, no `lspconfig.setup{}` calls):

- `lua_ls`
- `pyright`
- `clangd`

Servers must be installed separately (e.g. via `mason.nvim`, or system package manager — not bundled in this config).

## Editor options

| Option | Value | Effect |
|---|---|---|
| `number` / `relativenumber` | on | Hybrid line numbers |
| `signcolumn` | `yes` | Always show sign column |
| `tabstop` / `shiftwidth` | 2 | 2-space indent |
| `expandtab` | on | Spaces, not tabs |
| `wrap` | off | No line wrap |
| `hlsearch` | off | No persistent search highlight |
| `ignorecase` / `smartcase` | on | Case-insensitive unless uppercase used |
| `mouse` | `nvi` | Mouse in normal/visual/insert |
| `swapfile` | off | No `.swp` files |
| `scrolloff` | 10 | Keep 10 lines of context when scrolling |
| `completeopt` | `menu,menuone,noinsert` | Completion menu behavior |

## Keymaps

Leader: `<Space>`. Local leader: `\`.

| Mode | Key | Action |
|---|---|---|
| n, x | `gy` | Copy to system clipboard |
| n, x | `gp` | Paste from system clipboard |
| n | `<leader>q` | Quit |
| n | `<leader>Q` | Quit without saving |
| n | `<leader>w` | Save file |
| n | `<leader>e` | Open file explorer (`MiniFiles`) |
| n | `<leader>bn` | Next buffer |
| n | `<leader>bp` | Previous buffer |
| n | `<leader>bd` | Delete buffer |
| n | `<C-h/j/k/l>` | Tmux-aware pane navigation |
| n | `<C-\>` | Tmux navigate previous pane |

`mini.clue` shows contextual hints for `<Leader>`, `g`, `z`, `'`, `` ` ``, `"`, `<C-w>`, `<C-x>` (insert completion), `<C-r>` (registers).

## Installation

```bash
git clone https://github.com/3XA2D/3XANVIM/ ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself on first launch and installs all plugins automatically. Run `:TSUpdate` after first launch for treesitter parsers (auto-install currently disabled — see Notes).

## Notes

- `after/plugin/treesitter.lua` setup block is **commented out** — treesitter plugin loads (via `lazy=false`) but no parsers/highlighting are configured yet.
- No `mason.nvim` — LSP servers (`lua_ls`, `pyright`, `clangd`) must be installed manually and be on `$PATH`.
- No completion source plugins (e.g. `nvim-cmp`, `blink.cmp`) — relies solely on `mini.completion`.
- No autoformatting/linting plugin configured.
- Format Lua source with `stylua` (config in `stylua.toml`: 2-space indent, double quotes preferred, 120 col width).
