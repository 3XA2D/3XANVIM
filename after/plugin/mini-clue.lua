local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "i", keys = "<C-x><C-f>", desc = "File names" },
    { mode = "i", keys = "<C-x><C-l>", desc = "Whole lines" },
    { mode = "i", keys = "<C-x><C-o>", desc = "Omni completion" },
    { mode = "i", keys = "<C-x><C-s>", desc = "Spelling suggestions" },
    { mode = "i", keys = "<C-x><C-u>", desc = "With 'completefunc'" },
  },

  window = {
    -- Show window immediately
    delay = 0,
    config = {
      width = "auto",
    },
    scroll_down = "<C-n>",
    scroll_up = "<C-p>",
  },
})
