local M = {
  "saghen/blink.cmp",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    "folke/lazydev.nvim",
  },
  version = "*",
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

    snippets = {
      preset = "luasnip",
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "dadbod", "lazydev" },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
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
        border = "rounded",
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
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
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
