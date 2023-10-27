local rt = require("rust-tools")
rt.setup({
  tools = {
    inlay_hints = {
      -- automatically set inlay hints (type hints)
      -- default: true
      auto = false,
    }
  }
})
