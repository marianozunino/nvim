return {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require("schemastore").yaml.schemas({
        -- additional schemas (not in the catalog)
        extra = {
          url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
          name = "Argo CD Application",
          fileMatch = "argocd-application.yaml",
        },
      }),
    },
  },
}
