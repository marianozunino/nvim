return {
  settings = {
    cmd = {
      "clangd",
      "--clang-tidy",
      "-j=5",
      "--malloc-trim",
    },
    filetypes = { "c" }, -- "cpp"
  },
}
