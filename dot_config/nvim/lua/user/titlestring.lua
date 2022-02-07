
-- Window Title
vim.cmd [[
  function! SetTitleString()
      let &titlestring="NVIM" . " - " . fnamemodify(getcwd(), ':t') . " - " . expand("%:t")
  endfunction
  if exists('g:neovide')
      set title
      call SetTitleString()
      augroup dirchange
          autocmd!
          autocmd DirChanged * call SetTitleString()
      augroup END
      augroup bufenter
          autocmd!
          autocmd BufEnter * call SetTitleString()
      augroup END
  endif
]]
