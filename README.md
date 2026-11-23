# 3XANVIM

Minimalist single-file Neovim configuration. Lua-only, `lazy.nvim` plugin manager, `mini.nvim`-centric.

## Structure

```text
.
└── init.lua                    # Single-file config (options, plugins, keymaps, LSP, Godot pipe)
```

**Load order:** Editor options → `lazy.nvim` bootstrap → `mini.nvim` setup (editing modules, completion, `mini.clue`, `mini.files` hint overlay, `minispring` colorscheme) → lazy-loaded plugins (`mason-lspconfig`, `vim-tmux-navigator`, `typst-preview.nvim`, `vim-godot`) → keymaps → Godot `server.pipe` auto-start.

## Plugins

| Plugin | Purpose |
| :--- | :--- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Core editing & UI suite (see below) |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server installer |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Automatic LSP installation & enablement |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Default LSP server configurations |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless tmux/vim pane navigation |
| [typst-preview.nvim](https://github.com/chomosuke/typst-preview.nvim) | Live Typst document preview |
| [vim-godot](https://github.com/habamax/vim-godot) | Godot file detection & integration |

### `mini.nvim` modules in use

- `mini.comment` — commenting
- `mini.pairs` — auto-close brackets/quotes
- `mini.surround` — add/change/delete surroundings
- `mini.move` — move lines/selections
- `mini.statusline` — statusline (icons disabled)
- `mini.files` — file explorer (`<CR>` to enter dir, preview enabled, floating keybind hint on `g?`)
- `mini.completion` — autocompletion (LSP `omnifunc` + always-active fallback across all loaded buffers)
- `mini.clue` — contextual keymap hint popup

Colorscheme: `minispring` (from `mini.nvim`), with `Normal`/`NonText` background cleared for terminal transparency. Falls back to `default` colorscheme if `minispring` fails to load.

## LSP servers

Installed and enabled automatically via `mason-lspconfig.nvim`:

- `lua_ls`
- `pyright`
- `clangd`

When no LSP client is attached to the current buffer, typing 2+ word characters automatically triggers completion sourced from words across all loaded buffers.

## Editor options

| Option | Value | Effect |
| :--- | :--- | :--- |
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
| `completeopt` | `menu,menuone,noselect` | Non-intrusive completion popup |

## Keymaps

Leader: `<Space>`. Local leader: `\`.

| Mode | Key | Action |
| :--- | :--- | :--- |
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
| n | `<localleader>p` | Toggle Typst preview (in `.typ` files) |

### `mini.files` keymaps

| Key | Action |
| :--- | :--- |
| `<CR>` / `l` | Open file / enter directory |
| `h` | Go to parent directory |
| `%` | Create new file |
| `d` | Delete entry |
| `r` | Rename entry |
| `=` | Synchronize / apply filesystem changes |
| `q` / `<Esc>` | Close explorer |
| `g?` | Toggle floating keybind hint |

`mini.clue` shows contextual hints for `<Leader>`, `g`, `z`, `'`, `` ` ``, `"`, `<C-w>`, `<C-x>` (insert completion), and `<C-r>` (registers).

## Installation

```bash
git clone https://github.com/3XA2D/3XANVIM ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself on first launch and installs all plugins automatically. `mason-lspconfig` automatically installs `lua_ls`, `pyright`, and `clangd` upon opening a code buffer.

## Notes

- **Godot integration:** Opening Neovim inside a directory containing `project.godot` (or its immediate subdirectory) automatically starts a Neovim RPC server at `<project_root>/server.pipe`. Set Godot's external editor exec path to `nvim` and exec flags to `--server {project}/server.pipe --remote-send "<C-\><C-N>:n {file}<CR>{line}G{col}|"`.
- **Startup optimization:** Built-in plugins (`netrwPlugin`, `gzip`, `tarPlugin`, `zipPlugin`, `tohtml`, `tutor`, `matchit`, `matchparen`) and background plugin update checks (`checker.enabled = false`) are disabled. Run `:Lazy sync` manually to update plugins.
