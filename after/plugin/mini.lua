require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.move").setup()
require("mini.starter").setup()
require("mini.tabline").setup()
require("mini.completion").setup()

require("mini.indentscope").setup({
  symbol = "¦",
})

require("mini.statusline").setup({
  use_icons = false,
})

require("mini.icons").setup({
  style = "ascii",
})

require("mini.files").setup({
  windows = {
    preview = true,
  },

  mappings = {
    go_in = "<CR>",
  },
})
