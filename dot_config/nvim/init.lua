require("user.dap")
require("user.options")
require("user.plugins")
require("user.titlestring")
require("user.notify")
require("user.lsp")
require("user.treesitter")
require("user.colorscheme")
require("user.hop")
require("user.trouble")
require("user.telescope")
require("user.fzf")
require("user.comment")
require("user.commands")
require("user.vsnip")
require("user.cmp")
require("user.floaterm")
require("user.nvim-tree")
require("user.neogit")
require("user.gitsigns")
require("user.git-conflict")
require("user.autopairs")
require("user.illuminate")
require("user.indent-blankline")
require("user.todo-comments")
require("user.rust")
require("user.browser")

require("user.cokeline")
require("user.lualine")
-- require("user.statusline") -- broken https://github.com/nvim-lua/lsp-status.nvim/issues/79

require("user.keymaps")

if vim.g.neovide then
  require("user.neovide")
end

-- Un-cache lua files in "user" directory
require('plenary.reload').reload_module('user', true)

