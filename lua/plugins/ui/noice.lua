local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
}

M.config = function()
  local noice = require("noice")

  noice.setup({
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d fewer lines" },
            { find = "%d more lines" },
          },
        },
        opts = { skip = true },
      },
    },
    lsp = {
      progress = { enabled = true },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { silent = true },
      signature = {
        auto_open = { throttle = vim.api.nvim_get_option_value("updatetime", { scope = "global" }) },
      },
    },
    cmdline = {
      format = {
        cmdline = { icon = "" },
        search_down = { icon = " " },
        search_up = { icon = " " },
      },
    },
    messages = {
      enabled = false,
    },
    popupmenu = { enabled = true },
    presets = {
      bottom_search = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    throttle = 1000,
    views = {
      split = {
        enter = true,
        size = "25%",
        win_options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          list = false,
          wrap = false,
        },
      },
      popup = { border = { style = "rounded" } },
      hover = {
        border = { style = "rounded" },
        position = { row = 2, col = 2 },
      },
      mini = {
        timeout = 3000,
        position = { row = -2 },
        border = { style = "rounded" },
        win_options = {
          winblend = vim.api.nvim_get_option_value("winblend", { scope = "global" }),
        },
      },
      cmdline_popup = { border = { style = "rounded" } },
      confirm = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },
  })
end

return M
