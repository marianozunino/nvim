local M = {
  "folke/trouble.nvim",
  branch = "main",
}

local function setup_keymaps(trouble)
  -- Diagnostic navigation
  nmap("[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  nmap("]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

  -- Trouble specific navigation
  nmap("<a-k>", function()
    trouble.previous({ skip_groups = true, jump = true })
  end, { desc = "Previous trouble item" })
  nmap("<a-j>", function()
    trouble.next({ skip_groups = true, jump = true })
  end, { desc = "Next trouble item" })

  -- Trouble mode toggles
  nmap("<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Toggle trouble" })
  nmap("<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
  nmap("<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
  nmap("<leader>tq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix list" })
  nmap("<leader>tl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list" })
end

local function setup_diagnostic_config()
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      suffix = "",
      format = function(diagnostic)
        local icons = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        }
        local icon = icons[diagnostic.severity] or ""
        return string.format("%s %s", icon, diagnostic.message)
      end,
    },
    underline = false,
    update_in_insert = false,
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
      format = function(diagnostic)
        local severity = vim.diagnostic.severity[diagnostic.severity]
        return string.format("%s: %s", severity:lower(), diagnostic.message)
      end,
    },
    severity_sort = true,
  })
end

function M.config()
  local trouble = require("trouble")

  trouble.setup({
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    action_keys = {
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" }, -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" }, -- open buffer in new tab
      toggle_mode = "m", -- toggle between "workspace" and "document" mode
      toggle_preview = "P", -- toggle auto_preview
      preview = "p", -- preview the diagnostic location
      close_folds = { "zM", "zm" }, -- close all folds
      open_folds = { "zR", "zr" }, -- open all folds
      toggle_fold = { "zA", "za" }, -- toggle fold of current file
      previous = "k", -- previous item
      next = "j", -- next item
    },
    auto_preview = true,
    auto_fold = false,
    auto_jump = { "lsp_definitions" },
    signs = {
      -- Icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "",
    },
    use_diagnostic_signs = false,
  })

  -- Setup keymaps
  setup_keymaps(trouble)

  -- Setup diagnostic configuration
  setup_diagnostic_config()
end

return M
