-- ========================================================================= --
-- ==                              KEYMAPS                                == --
-- ========================================================================= --

-- Helper function
local map = function(mode, key, com, desc)
  vim.keymap.set(mode, key, com, { desc = desc })
end

local cmd = function(com)
  return "<cmd>" .. com .. "<cr>"
end

-- Use <Space> as a leader key
vim.g.mapleader = " "

-- Copy/paste using system clipboard
map({ "n", "x" }, "gy", '"+y', "Copy to system")
map({ "n", "x" }, "gp", '"+p', "Paste from system")

-- Exit Neovim
map("n", "<leader>q", cmd("q"), "Quit")
map("n", "<leader>Q", cmd("q!"), "Quit witouth saving")

-- Save file
map("n", "<leader>w", cmd("w"), "Save file")

-- File (MiniFiles)
map("n", "<leader>e", cmd("lua MiniFiles.open()"), "Open file explorer")

-- Buffer
map("n", "<leader>bn", cmd("bn"), "Next buffer") -- Next
map("n", "<leader>bp", cmd("bp"), "Previous buffer") -- Prev
map("n", "<leader>bd", cmd("bd"), "Delete buffer") -- Delete
