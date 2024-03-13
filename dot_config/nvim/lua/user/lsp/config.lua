local config = require("lspconfig")

config.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        runBuildScripts = true,
      },
    }
  }
})
config.tsserver.setup({})
config.graphql.setup({})
config.tailwindcss.setup({})
-- Doesn't support version 5 yet!
-- config.ocamllsp.setup({})
