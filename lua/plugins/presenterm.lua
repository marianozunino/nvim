return {
  "marianozunino/presenterm.nvim",
  config = function()
    require("presenterm").setup({

      patterns = {
        "*.presenterm",
        "*.pterm",
        "*.md",
      },

      auto_launch = true,
      terminal_cmd = "kitty --title 'Presenterm: {title}' --override font_size=18 {cmd}",
    })
  end,
}
