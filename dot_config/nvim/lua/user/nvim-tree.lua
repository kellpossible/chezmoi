require('nvim-tree').setup {
  -- disable_netrw = false,
  -- hijack_netrw  = false,
  update_cwd = true,
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
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
]]
