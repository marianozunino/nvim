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
