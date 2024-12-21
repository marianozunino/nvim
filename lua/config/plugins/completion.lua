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

      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    signature = {
      enabled = true,
    },

    completion = {
      accept = {
        create_undo_point = true,
        auto_brackets = {
          enabled = true,
        },
      },
    },
  })
end

return M
