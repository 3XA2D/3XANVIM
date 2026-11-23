# 3XANVIM

Personal Neovim config. Single-file Lua (`init.lua`), `lazy.nvim` plugin manager, `mini.nvim`-centric.

## Structure

```
.
└── init.lua                    # Options, lazy.nvim bootstrap, plugins, keymaps, LSP, Godot pipe
```

**Load order (inside `init.lua`):** Editor options & leaders → `lazy.nvim` bootstrap & plugin specs (`mini.nvim` loads immediately at priority 1000; others are lazy-loaded) → Keymaps → Godot `server.pipe` detection.

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Modular plugin suite (see below) |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Auto-installs and enables LSP servers |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server package manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless tmux/vim pane navigation |
| [typst-preview.nvim](https://github.com/chomosuke/typst-preview.nvim) | Live Typst document preview |
| [vim-godot](https://github.com/habamax/vim-godot) | Godot / GDScript filetype & tooling support |

### mini.nvim modules in use

- `mini.comment` — commenting
- `mini.pairs` — auto-close brackets/quotes
- `mini.surround` — add/change/delete surroundings
    - `mini.move` — move lines/selections
    - `mini.completion` — autocompletion (LSP + custom `completefunc` across all loaded buffers)
    - `mini.statusline` — statusline (icons disabled)
- `mini.files` — file explorer (preview enabled, `<CR>` to enter dir, floating keybind overlay)
    - `mini.clue` — keymap hint popup

    Colorscheme: `minispring` (from mini.nvim), with `Normal`/`NonText` background cleared for terminal transparency. Falls back to `default` colorscheme if `minispring` fails to load.

## LSP servers

    Managed via `mason-lspconfig.nvim` (`ensure_installed` + `automatic_enable = true` on Neovim 0.11+ native API):

        - `lua_ls`
        - `pyright`
        - `clangd`

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
        | `completeopt` | `menu,menuone,noselect` | Non-intrusive popup completion menu |

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
        | n | `<localleader>p` | Toggle Typst preview (`.typ` files) |
        | n | `g?` | Toggle keybind hint overlay (inside `MiniFiles`) |

        `mini.clue` shows contextual hints for `<Leader>` (`+Buffer`), `g`, `z`, `'`, `` ` ``, `"`, `<C-w>`, `<C-x>` (insert completion), and `<C-r>` (registers).

## Installation

        ```bash
        git clone https://github.com/3XA2D/3XANVIM/ ~/.config/nvim
        nvim
        ```

        `lazy.nvim` bootstraps itself on first launch and installs all plugins automatically. `mason-lspconfig` installs `lua_ls`, `pyright`, and `clangd` on buffer read/creation.

## Notes

        - Requires Neovim `>= 0.11` (`vim.uv`, `vim.lsp.get_clients`, and `automatic_enable` native LSP API).
        - Built-in plugins (`netrwPlugin`, `gzip`, `tarPlugin`, `zipPlugin`, `tohtml`, `tutor`, `matchit`, `matchparen`) are disabled via `lazy.nvim` `performance.rtp` for faster startup.
        - When no LSP client is attached to the current buffer, `InsertCharPre` automatically triggers `<C-x><C-u>` (`LoadedBuffersComplete`) to complete words from all currently loaded buffers.
        - If `project.godot` exists in `cwd` or `cwd/..`, Neovim automatically starts a headless RPC server at `server.pipe`.
