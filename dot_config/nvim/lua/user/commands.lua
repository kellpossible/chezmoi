-- Set shiftwidth based on file type
vim.cmd [[autocmd FileType lua set shiftwidth=2]]

-- Highlight when yanking
vim.cmd [[
  augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  augroup END
]]

function rgr_input()
    local query = vim.fn.input("Rgr Search: ", "")
    local args = vim.fn.input("Ripgrep Args: ", "")
    vim.cmd("FloatermNew --autoclose=1 --wintype=split " .. "rgr " .. args .. " " .. query)
end

vim.cmd [[

  function! RunBacon()
    execute "FloatermNew --wintype=vsplit --autoclose=1 --width=0.4 bacon clippy-all"
    stopinsert
    wincmd h
  endfunction
  command! Broot FloatermNew --width=0.8 --height=0.8 broot
  command! NNN FloatermNew nnn
  command! FFF FloatermNew fff
  command! LF FloatermNew lf
  command! Ranger FloatermNew ranger
  command! Rgr lua rgr_input()
  command! Bacon call RunBacon()
]]
