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
config.elixirls.setup{}
config.jinja_lsp.setup({
  filetypes = { "jinja", "jinja.html" },
  settings = {
    templates = "./src/templates",
    backend = "./src",
    lang = "rust",
  },
})
config.gleam.setup{}
-- Doesn't support version 5 yet!
-- config.ocamllsp.setup({})
