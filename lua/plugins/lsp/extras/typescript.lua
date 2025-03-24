return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "typescript", "javascript", "jsx", "tsx", "json" },
  config = function()
    local lsp_common = require("plugins.lsp").get_common_config()
    local ts_api = require("typescript-tools.api")
    local original_on_attach = lsp_common.on_attach

    lsp_common.on_attach = function(client, bufnr)
      original_on_attach(client, bufnr)
      vim.keymap.set("n", "<leader>ca", function()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        local context = { diagnostics = diagnostics }
        local params = vim.lsp.util.make_range_params(0)
        params.context = context

        params = vim.tbl_extend("force", {}, params)
        vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, result, ctx)
          local actions = result or {}
          table.insert(actions, { title = "Organize Imports", command = "typescript.custom.organize_imports" })
          table.insert(actions, { title = "Fix All", command = "typescript.custom.fix_all" })
          table.insert(actions, { title = "Add Missing Imports", command = "typescript.custom.add_missing_imports" })
          table.insert(actions, { title = "Remove Unused", command = "typescript.custom.remove_unused" })
          vim.ui.select(actions, {
            prompt = "Code Actions",
            format_item = function(action)
              return action.title
            end,
          }, function(action)
            if not action then
              return
            end
            if action.command == "typescript.custom.organize_imports" then
              pcall(ts_api.organize_imports)
            elseif action.command == "typescript.custom.fix_all" then
              pcall(ts_api.fix_all)
            elseif action.command == "typescript.custom.add_missing_imports" then
              pcall(ts_api.add_missing_imports)
            elseif action.command == "typescript.custom.remove_unused" then
              pcall(ts_api.remove_unused)
            else
              if action.edit or type(action.command) == "table" then
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                end
                if type(action.command) == "table" then
                  vim.lsp.buf.execute_command(action.command)
                end
              end
            end
          end)
        end)
      end, { buffer = bufnr, desc = "Code Actions" })
    end

    require("typescript-tools").setup(vim.tbl_deep_extend("force", lsp_common, {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
      },
    }))
  end,
}
