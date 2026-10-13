return {
  {
    "chomosuke/typst-preview.nvim",
    lazy = false,
    version = "1.*",
    build = function() require("typst-preview").update() end,
    keys = {
      { "<localleader>p", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
    },
  },
  {
    "kaarmu/typst.vim",
    ft = "typst",
    lazy = false,
  }
}
