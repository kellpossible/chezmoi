require("user.options")
require("user.plugins")
require("user.mason")

require("user.dap")
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
-- require("user.vsnip")
require("user.snippy")
require("user.cmp")
require("user.floaterm")
require("user.nvim-tree")
require("user.neogit")
require("user.git-blame")
require("user.git-conflict")
require("user.gitsigns")
-- require("user.vgit") -- broken
require("user.autopairs")
require("user.illuminate")
require("user.indent-blankline")
require("user.todo-comments")
require("user.rust")
require("user.browser")
require("user.scroll")
require("user.harpoon")
require("user.chatgpt")

-- require("user.cokeline")
-- require("user.lualine")
require("user.statusline") -- broken https://github.com/nvim-lua/lsp-status.nvim/issues/79

require("user.keymaps")

if vim.g.neovide then
  require("user.neovide")
end

-- Un-cache lua files in "user" directory
require('plenary.reload').reload_module('user', true)

