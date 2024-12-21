local M = {
  {
    "laytan/cloak.nvim",
    config = function()
      require("cloak").setup({
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
          {
            file_pattern = {
              ".env*",
              "wrangler.toml",
              ".dev.vars",
            },
            cloak_pattern = "=.+",
          },
        },
      })

      nmap("<Leader>cc", ":CloakToggle<cr>")
    end,
  },
  {
    "philosofonusus/ecolog.nvim",
    keys = {
      { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
      { "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
      { "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    },
    -- Lazy loading is done internally
    lazy = false,
    opts = {
      integrations = {
        blink_cmp = true,
      },
      -- Enables shelter mode for sensitive values
      shelter = {
        configuration = {
          partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
          mask_char = "*", -- Character used for masking
        },
        modules = {
          cmp = true, -- Mask values in completion
          peek = false, -- Mask values in peek view
          files = false, -- Mask values in files
          telescope = false, -- Mask values in telescope
        },
      },
      -- true by default, enables built-in types (database_url, url, etc.)
      types = true,
      path = vim.fn.getcwd(), -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
    },
  },
}

M.config = function() end

return M
