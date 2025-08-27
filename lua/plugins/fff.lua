return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {},
  keys = {
    {
      "<leader>/",
      function()
        require("fff").find_files()
      end,
      desc = "Toggle FFF",
    },
  },
}
