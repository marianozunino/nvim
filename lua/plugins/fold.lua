return {
  "kevinhwang91/nvim-ufo",
  event = "BufRead",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set("n", "zA", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zC", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zk", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek Fold" })

    require("ufo").setup({
      provider_selector = function()
        return { "lsp", "indent" }
      end,
    })
  end,
}
