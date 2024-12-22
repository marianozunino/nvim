return {
  "yioneko/nvim-vtsls",
  dependencies = {
    "dmmulroy/ts-error-translator.nvim",
  },
  config = function()
    require("ts-error-translator").setup()
  end,
  ft = { "typescript", "javascript", "jsx", "tsx", "json" },
}
