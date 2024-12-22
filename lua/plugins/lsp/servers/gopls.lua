return {
  settings = {
    gopls = {
      gofumpt = true, -- https://github.com/mvdan/gofumpt a stricter gofmt
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
  flags = {
    debounce_text_changes = 150, -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#change-detection
  },
}
