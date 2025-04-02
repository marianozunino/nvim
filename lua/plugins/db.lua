local M = {
  "tpope/vim-dadbod",
  cmd = {
    "DBUI",
  },
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
}

M.config = function()
  vim.g.db_ui_use_nerd_fonts = 1
  -- g:db_ui_save_location
  vim.g.db_ui_save_location = "~/Sync/Work/Stuzo/queries"
end

return M
