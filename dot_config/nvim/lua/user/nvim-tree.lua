require('nvim-tree').setup {
  git = {
    ignore = false,
    enable = true,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  }
}

vim.cmd [[
  let g:nvim_tree_highlight_opened_files = 1
  let g:nvim_tree_git_hl = 1
]]
