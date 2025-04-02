local M = {
  "stevearc/oil.nvim",
}

M.config = function()
  local function max_height()
    local height = vim.fn.winheight(0)
    if height >= 40 then
      return 30
    elseif height >= 30 then
      return 20
    else
      return 10
    end
  end

  require("oil").setup({
    keymaps = {
      ["<C-p>"] = false,
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
    },
    -- Set to false if you still want to use netrw.
    default_file_explorer = true,
    delete_to_trash = true,

    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,

    view_options = {
      natural_order = true,
      -- Show files and directories that start with "."
      show_hidden = false,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name)
        local ignore_folders = { "node_modules", "dist", "build", "coverage" }
        return vim.startswith(name, ".") or vim.tbl_contains(ignore_folders, name)
      end,
      wrap = true,
    },

    -- Configuration for the floating window in oil.open_float
    float = {
      padding = 2,
      max_width = 120,
      max_height = max_height(),
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  })

  nmap("-", require("oil").open, { desc = "Open parent directory" })

  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
      if event.data.actions.type == "move" then
        Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
      end
    end,
  })
end

return M
