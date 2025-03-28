return {
  dir = "/home/forbi/Dev/marianozunino/presenterm.nvim",
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

    nmap("<leader>pl", ":PresentermLaunch<cr>", { desc = "[Presenterm] Launch" })
    nmap("<leader>ps", ":PresentermStop<cr>", { desc = "[Presenterm] Stop" })
  end,
}
