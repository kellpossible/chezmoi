local lsp_installer = require("nvim-lsp-installer")


local codelldb_path = "/usr/bin/codelldb"
local liblldb_path = "/usr/lib/liblldb.so"

lsp_installer.on_server_ready(function(server)
    if server.name == "sumneko_lua" then
      local opts = {}
      local sumneko_opts = require("user.lsp.settings.sumneko_lua")
      opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

    if server.name == "rust_analyzer" then
      -- Initialize the LSP via rust-tools instead
      local opts = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              runBuildScripts = true,
            },
          },
        },
      }
      require("rust-tools").setup {
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,
        -- The "server" property provided in rust-tools setup function are the
        -- settings rust-tools will provide to lspconfig during init.
        -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
        -- with the user's own settings (opts).
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path
          )
        }
      }
      server:attach_buffers()
    else
        server:setup({})
    end
end)
