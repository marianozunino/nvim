return {
  "folke/snacks.nvim",
  priority = 1000,
  config = function()
    local snacks = require("snacks")
    snacks.setup({
      bigfile = { enabled = true },
      debug = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      rename = { enabled = true },
      notifier = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
      },
      dashboard = {
        preset = {
          keys = function()
            return {
              { icon = "⏻", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
              { icon = "󱇧", key = "e", desc = "New Buffer", action = "<cmd>ene<CR>" },
            }
          end,
          header = table.concat({
            [[   █  █   ]],
            [[   █ ██   ]],
            [[   ████   ]],
            [[   ██ ███   ]],
            [[   █  █   ]],
            [[             ]],
            [[ n e o v i m ]],
          }, "\n"),
        },
        sections = {
          {
            section = "header",
          },
          { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
          { section = "recent_files", cwd = true, limit = 10, padding = 1 },
          { title = "GMRU", padding = 1 },
          { section = "recent_files", limit = 5, padding = 1 },
          { title = "Sessions", padding = 1 },
          { section = "projects", padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
        },
      },
    })

    nmap("<leader>.", snacks.scratch.open, { desc = "Toggle Scratch Buffer" })
    nmap("<leader>,", snacks.scratch.select, { desc = "Select Scratch Buffer" })
    -- Show notifier history
    nmap("<leader>ns", snacks.notifier.show_history, { desc = "Show notifier history" })
  end,
}
