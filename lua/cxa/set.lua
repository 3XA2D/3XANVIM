-- ========================================================================= --
-- ==                          EDITOR SETTINGS                            == --
-- ========================================================================= --

local o = vim.o
local g = vim.g
local cmd = vim.cmd

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.wrap = false
o.hlsearch = false
o.smartcase = true
o.ignorecase = true
o.mouse = "nvi"
o.swapfile = false
o.completeopt = "menu,menuone,noinsert"
o.scrolloff = 10

local ok_theme = pcall(function()
  o.termguicolors = true
  o.cursorline = true
  cmd("colorscheme minisummer")
  cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  ]])
end)

if not ok_theme then
  o.termguicolors = false
  o.cursorline = false
  cmd("colorscheme default")
  cmd("highlight clear SignColumn")
end
