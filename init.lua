-- Fuck off with the warnings...
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

require("globals")
require("config.options")
require("config.remap")
require("config.autocomands")
require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local config_path = vim.fn.stdpath("config")
    local current_dir = vim.fn.getcwd()
    if current_dir == config_path then
      vim.fn.system("git config core.hooksPath .githooks")
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to set git hooks path for Neovim config", vim.log.levels.WARN)
      end
    end
  end,
  desc = "Set git hooks path for Neovim config directory only",
})

-- Define a highlight group for the floating filename
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Create a highlight group for the floating window text
    vim.cmd("highlight ClaseFloatText guifg=#FFD700 guibg=#1E1E2E") -- gold text on dark background

    local config_path = vim.fn.stdpath("config")
    local current_dir = vim.fn.getcwd()
    if current_dir == config_path then
      vim.fn.system("git config core.hooksPath .githooks")
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to set git hooks path for Neovim config", vim.log.levels.WARN)
      end
    end
  end,
  desc = "Set git hooks path for Neovim config directory only",
})

vim.g.clase_floating_enabled = false

local function toggle_lsp_features(enable)
  if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
    pcall(vim.lsp.inlay_hint.enable, enable)
  end
end

local function show_filename_float()
  local enabled = vim.g.clase_floating_enabled
  local ft = vim.bo.filetype
  local filename = vim.fn.expand("%:~:.")
  local should_skip = not enabled or ft == "oil" or filename == ""

  if should_skip then
    if vim.g.filename_float_win and vim.api.nvim_win_is_valid(vim.g.filename_float_win) then
      vim.api.nvim_win_close(vim.g.filename_float_win, true)
      vim.g.filename_float_win = nil
    end
    return
  end

  if vim.g.filename_float_win and vim.api.nvim_win_is_valid(vim.g.filename_float_win) then
    vim.api.nvim_win_close(vim.g.filename_float_win, true)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local text = "🗂 " .. filename
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
  -- Apply the highlight group to the entire line
  vim.api.nvim_buf_add_highlight(buf, -1, "ClaseFloatText", 0, 0, -1)

  local width = vim.fn.strdisplaywidth(text) + 2
  local opts = {
    relative = "editor",
    width = width,
    height = 1,
    row = 0,
    col = vim.o.columns - width,
    style = "minimal",
    focusable = false,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, false, opts)
  vim.g.filename_float_win = win
end

-- Autocomando para actualizar en cambios de buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = show_filename_float,
})

-- Enhanced :Class command that also toggles inlay hints and diagnostics
vim.api.nvim_create_user_command("Class", function()
  vim.g.clase_floating_enabled = not vim.g.clase_floating_enabled

  if not vim.g.clase_floating_enabled then
    -- Class mode OFF: Restore normal behavior
    if vim.g.filename_float_win and vim.api.nvim_win_is_valid(vim.g.filename_float_win) then
      vim.api.nvim_win_close(vim.g.filename_float_win, true)
      vim.g.filename_float_win = nil
    end
    toggle_lsp_features(true) -- Enable LSP features
    vim.opt.relativenumber = true -- Restore relative numbers
  else
    -- Class mode ON: Minimal UI for students
    show_filename_float()
    toggle_lsp_features(false) -- Disable LSP features
    vim.opt.relativenumber = false -- Hide relative numbers
  end
end, {})
