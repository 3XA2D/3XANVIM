local lsp = vim.lsp

local lang = {
  "lua_ls",
  "pyright",
  "clangd",
}

for i = 1, #lang do
  lsp.enable(lang[i])
end
