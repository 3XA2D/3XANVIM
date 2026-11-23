-- ========================================================================= --
-- 1. LEADER & EDITOR OPTIONS
-- ========================================================================= --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.o
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.wrap = false
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.mouse = "nvi"
o.swapfile = false
o.completeopt = "menu,menuone,noselect"
o.scrolloff = 10
o.termguicolors = true
o.cursorline = true

-- ========================================================================= --
-- 2. BOOTSTRAP LAZY.NVIM
-- ========================================================================= --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================= --
-- 3. PLUGINS (MINIMALIS & TINGGI QOL)
-- ========================================================================= --
require("lazy").setup({
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("mini.comment").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.move").setup()
      require("mini.statusline").setup({ use_icons = false })

      require("mini.files").setup({
        windows = { preview = true },
        mappings = { go_in = "<CR>" },
      })

      -- ------------------------------------------------------------------- --
      -- MINI.FILES KEYBIND HINT OVERLAY
      -- ------------------------------------------------------------------- --
      local minifiles_hint_win = nil
      local minifiles_hint_buf = nil

      local hint_lines = {
        " mini.files keybinds ",
        " <CR> / l : open / go in ",
        " h        : go out ",
        " %        : new file ",
        " d        : delete entry ",
        " r        : rename entry ",
        " =        : apply changes ",
        " q / <Esc>: close ",
        " g?       : toggle hint ",
      }

      local function close_minifiles_hint()
        if minifiles_hint_win and vim.api.nvim_win_is_valid(minifiles_hint_win) then
          vim.api.nvim_win_close(minifiles_hint_win, true)
        end
        minifiles_hint_win = nil
      end

      local function open_minifiles_hint()
        close_minifiles_hint()

        if not minifiles_hint_buf or not vim.api.nvim_buf_is_valid(minifiles_hint_buf) then
          minifiles_hint_buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(minifiles_hint_buf, 0, -1, false, hint_lines)
          vim.bo[minifiles_hint_buf].modifiable = false
          vim.bo[minifiles_hint_buf].bufhidden = "wipe"
        end

        local width = 0
        for _, line in ipairs(hint_lines) do
          if #line > width then
            width = #line
          end
        end

        minifiles_hint_win = vim.api.nvim_open_win(minifiles_hint_buf, false, {
          relative = "editor",
          anchor = "SE",
          row = vim.o.lines - 2,
          col = vim.o.columns - 1,
          width = width,
          height = #hint_lines,
          style = "minimal",
          border = "rounded",
          focusable = false,
          noautocmd = true,
        })
      end

      local function toggle_minifiles_hint()
        if minifiles_hint_win and vim.api.nvim_win_is_valid(minifiles_hint_win) then
          close_minifiles_hint()
        else
          open_minifiles_hint()
        end
      end

      local mf_augroup = vim.api.nvim_create_augroup("MiniFilesKeybindHint", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = mf_augroup,
        pattern = "minifiles",
        callback = function(ev)
          open_minifiles_hint()
          vim.keymap.set("n", "g?", toggle_minifiles_hint, {
            buffer = ev.buf,
            desc = "Toggle mini.files keybind hint",
            silent = true,
          })
          vim.api.nvim_create_autocmd({ "BufLeave", "WinClosed" }, {
            group = mf_augroup,
            buffer = ev.buf,
            once = true,
            callback = close_minifiles_hint,
          })
        end,
      })

      -- ------------------------------------------------------------------- --
      -- COMPLETION: SELALU AKTIF + KATA DARI SEMUA BUFFER YANG TER-LOAD
      -- ------------------------------------------------------------------- --
      local function collect_loaded_buffer_words(cur_buf)
        local words = {}
        local seen = {}

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local tag = (buf == cur_buf) and "[cur]" or ("[buf:" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") .. "]")
            for _, line in ipairs(lines) do
              for word in line:gmatch("[%a_][%w_%-%.]+") do
                if #word >= 2 and not seen[word] then
                  seen[word] = true
                  words[#words + 1] = {
                    word = word,
                    menu = tag,
                    dup = 0,
                  }
                end
              end
            end
          end
        end

        return words
      end

      function _G.LoadedBuffersComplete(findstart, base)
        if findstart == 1 then
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local prefix = line:sub(1, col)
          local start_pos = prefix:match("()[%a_][%w_%-%.]*$")
          return start_pos and (start_pos - 1) or -1
        end

        local cur_buf = vim.api.nvim_get_current_buf()
        local all_words = collect_loaded_buffer_words(cur_buf)
        if base == "" then
          return all_words
        end

        local matches = {}
        local base_lower = base:lower()
        for _, item in ipairs(all_words) do
          if item.word:lower():find(base_lower, 1, true) == 1 and item.word ~= base then
            matches[#matches + 1] = item
          end
        end
        return matches
      end

      vim.o.completefunc = "v:lua.LoadedBuffersComplete"

      require("mini.completion").setup({
        delay = { completion = 40, info = 100, signature = 50 },
        window = {
          info = { border = "rounded" },
          signature = { border = "rounded" },
        },
        lsp_completion = {
          source_func = "omnifunc",
          auto_setup = true,
        },
      })

      local comp_augroup = vim.api.nvim_create_augroup("AlwaysActiveBufferCompletion", { clear = true })
      vim.api.nvim_create_autocmd("InsertCharPre", {
        group = comp_augroup,
        callback = function()
          if vim.fn.pumvisible() == 1 then
            return
          end

          local char = vim.v.char
          if not char:match("[%a_%.]") then
            return
          end

          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before = line:sub(1, col) .. char
          local token = before:match("[%a_][%w_%-%.]*$")
          if not token or #token < 2 then
            return
          end

          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            vim.schedule(function()
              if vim.api.nvim_get_mode().mode == "i" and vim.fn.pumvisible() == 0 then
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes("<C-x><C-u>", true, false, true),
                  "n",
                  false
                )
              end
            end)
          end
        end,
      })

      -- ------------------------------------------------------------------- --
      -- MINI.CLUE (LENGKAP)
      -- ------------------------------------------------------------------- --
      local clue = require("mini.clue")
      clue.setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "i", keys = "<C-x>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },
          { mode = "n", keys = "<C-w>" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          { mode = "n", keys = "<leader>b", desc = "+Buffer" },
          clue.gen_clues.builtin_completion(),
          clue.gen_clues.g(),
          clue.gen_clues.marks(),
          clue.gen_clues.registers(),
          clue.gen_clues.windows(),
          clue.gen_clues.z(),
          { mode = "i", keys = "<C-x><C-f>", desc = "File names" },
          { mode = "i", keys = "<C-x><C-l>", desc = "Whole lines" },
          { mode = "i", keys = "<C-x><C-o>", desc = "Omni / LSP completion" },
          { mode = "i", keys = "<C-x><C-s>", desc = "Spelling suggestions" },
          { mode = "i", keys = "<C-x><C-u>", desc = "Loaded buffers words" },
        },
        window = {
          delay = 0,
          config = { width = "auto" },
          scroll_down = "<C-n>",
          scroll_up = "<C-p>",
        },
      })

      -- Colorscheme & Transparansi
      local ok = pcall(vim.cmd, "colorscheme minispring")
      if ok then
        for _, grp in ipairs({ "Normal", "NonText" }) do
          vim.api.nvim_set_hl(0, grp, { bg = "none", ctermbg = "none" })
        end
      else
        o.termguicolors = false
        o.cursorline = false
        vim.cmd("colorscheme default")
        vim.cmd("highlight clear SignColumn")
      end
    end,
  },

  -- LSP + Installer Otomatis (Mason)
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "clangd" },
      automatic_enable = true,
    },
  },

  -- Tmux Navigation
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Typst Preview
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function() require("typst-preview").update() end,
    keys = { { "<localleader>p", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview" } },
  },

  -- Godot
  { "habamax/vim-godot", ft = { "gd", "gdscript", "gdshader" } },
}, {
  defaults = { lazy = true },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- ========================================================================= --
-- 4. KEYMAPS
-- ========================================================================= --
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

map({ "n", "x" }, "gy", '"+y', "Copy to system")
map({ "n", "x" }, "gp", '"+p', "Paste from system")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<leader>Q", "<cmd>q!<cr>", "Quit without saving")
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>e", function() MiniFiles.open() end, "File explorer")
map("n", "<leader>bn", "<cmd>bn<cr>", "Next buffer")
map("n", "<leader>bp", "<cmd>bp<cr>", "Previous buffer")
map("n", "<leader>bd", "<cmd>bd<cr>", "Delete buffer")

-- ========================================================================= --
-- 5. GODOT SERVER PIPE
-- ========================================================================= --
local cwd = vim.fn.getcwd()
for _, rel in ipairs({ "", "/.." }) do
  local root = cwd .. rel
  if vim.uv.fs_stat(root .. "/project.godot") then
    local pipe = root .. "/server.pipe"
    if not vim.uv.fs_stat(pipe) then
      vim.fn.serverstart(pipe)
    end
    break
  end
end
