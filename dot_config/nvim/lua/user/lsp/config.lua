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
