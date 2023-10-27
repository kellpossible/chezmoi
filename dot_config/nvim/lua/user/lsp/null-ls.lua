local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

null_ls.setup({
	sources = {
		formatting.stylua,
		formatting.prettier.with({
			filetypes = {
				"html",
				"json",
				"yaml",
				"markdown",
				-- "javascript",
				-- "javascriptreact",
				-- "typescript",
				-- "typescriptreact",
				"graphql",
			},
		}),
		diagnostics.flake8,
		-- completion.spell,
	},
})
