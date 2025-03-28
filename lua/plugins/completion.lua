local M = {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
  version = "v1.*",
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
      ["<Tab>"] = { "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    snippets = { preset = "luasnip" },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "dadbod" },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "single",
      },
    },

    completion = {
      list = {
        selection = {
          auto_insert = true,
          preselect = false,
        },
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
        auto_show = function(ctx)
          return ctx.mode ~= "default"
        end,
      },
    },

    fuzzy = {
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
