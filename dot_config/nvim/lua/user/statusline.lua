-- Statusline
vim.cmd [[
  function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
      return luaeval("require('lsp-status').status()")
    endif

    return ''
  endfunction

  set statusline=
  set statusline+=\ %f
  set statusline+=%m
  set statusline+=\ %{LspStatus()}
  set statusline+=%=
  set statusline+=%#CursorColumn#
  set statusline+=\ %p%%
  set statusline+=\ %l:%c
]]
