mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = { "sumneko_lua", "rust_analyzer", "tsserver" },
})

-- local codelldb_path = "/usr/bin/codelldb"
-- local liblldb_path = "/usr/lib/liblldb.so"
-- mason_lspconfig.setup_handlers({
--   function (server_name)
--     lspconfig[server_name].setup()
--   end,
--   ["rust_analyzer"] = function()
--       local opts = {
--         settings = {
--           ["rust-analyzer"] = {
--             cargo = {
--               runBuildScripts = true,
--             },
--           },
--         },
--       }
--       require("rust-tools").setup {
--         -- automatically set inlay hints (type hints)
--         -- There is an issue due to which the hints are not applied on the first
--         -- opened file. For now, write to the file to trigger a reapplication of
--         -- the hints or just run :RustSetInlayHints.
--         -- default: true
--         autoSetHints = true,
--         -- The "server" property provided in rust-tools setup function are the
--         -- settings rust-tools will provide to lspconfig during init.
--         -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
--         -- with the user's own settings (opts).
--         server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
--         dap = {
--           adapter = require('rust-tools.dap').get_codelldb_adapter(
--             codelldb_path, liblldb_path
--           )
--         }
--       }
--   end,
-- })
