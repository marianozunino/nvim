local M = {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
}

M.config = function()
  require("blink.cmp").setup({
    keymap = {
      ["<C-space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
      },
      ["<C-d>"] = { "hide", "fallback" },
      ["<C-c>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    signature = {
      enabled = true,
      window = {
        border = "single",
      },
    },

    completion = {
      list = {
        -- Controls how the completion items are selected
        -- 'preselect' will automatically select the first item in the completion list
        -- 'manual' will not select any item by default
        -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
        selection = "auto_insert",
      },
      menu = {
        border = "single",
        draw = {
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },

    fuzzy = {
      -- When enabled, allows for a number of typos relative to the length of the query
      -- Disabling this matches the behavior of fzf
      use_typo_resistance = true,

      -- Frecency tracks the most recently/frequently used items and boosts the score of the item
      use_frecency = true,

      -- Proximity bonus boosts the score of items matching nearby words
      use_proximity = true,

      -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
      -- You may pass a function instead of a string to customize the sorting
      sorts = { "score", "sort_text" },
    },
  })
end

return M
