" Some great ideas for vim configuration here
" https://www.youtube.com/watch?v=434tljD-5C8

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'romgrk/nvim-treesitter-context'

" Plug 'vmchale/just-vim'
Plug 'NoahTheDuke/vim-just'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

" Monokai Theme with tresitter support
Plug 'tanvirtin/monokai.nvim'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp'
" cmp LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
" cmp Snippet completion
Plug 'hrsh7th/cmp-vsnip'
" cmp Path completion
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
" See hrsh7th other plugins for more great completion sources!

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Adds extra functionality over rust analyzer
Plug 'simrat39/rust-tools.nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" Find and replace Global
Plug 'nvim-pack/nvim-spectre'
" Find and replace Local
" Plug 'kqito/vim-easy-replace'
Plug 'folke/which-key.nvim'

" Unicode
Plug 'chrisbra/unicode.vim'

" File Tree
Plug 'kyazdani42/nvim-tree.lua'

" Visual Multi Selection
Plug 'mg979/vim-visual-multi'


" Move blocks of text
Plug 'fedepujol/move.nvim'

Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'wfxr/minimap.vim'

Plug 'TimUntersberger/neogit'

" Zoom for neovide

Plug 'drzel/vim-gui-zoom'

" Code action menu
" Plug 'weilbith/nvim-code-action-menu'
" TODO waiting for PR:
" https://github.com/weilbith/nvim-code-action-menu/pull/34
Plug 'filtsin/nvim-code-action-menu'

" Action lightbulb
" Plug 'kosayoda/nvim-lightbulb'

Plug 'ray-x/lsp_signature.nvim'

" Matching closing brackets
Plug 'windwp/nvim-autopairs'

" Floating Terminal
Plug 'voldikss/vim-floaterm'

" Highlight variables
Plug 'RRethy/vim-illuminate'

" Rusty Object Notation Syntax
Plug 'ron-rs/ron.vim'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

call plug#end()

" Open urls, workaround because netrw isn't working...
nmap gx yiW:!xdg-open <cWORD><CR> <C-r>" & <CR><CR>

" system clipboard
nmap <c-c> "+y
vmap <c-c> "+y
nmap <c-v> "+p
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <c-r> <c-v>

" Configure minimap
let g:minimap_auto_start = 0
let g:minimap_highlight_search = 1
let g:minimap_git_colors = 1

" Configure comment
lua require('Comment').setup()

" Configure neogit
lua require('neogit').setup()


" Tree Sitter Configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}
EOF

" General Editor Settings
syntax on
colorscheme monokai_pro
set mouse=a
set number
set expandtab
set shiftwidth=4
set tabstop=4
set list
set listchars=tab:▸\ ,trail:· " Show things that I normally don't want

" Reselect selection after indentation
vnoremap < <gv
vnoremap > >gv

" Allow gf to open non-existent files
map gf :edit <cfile><cr>

" Floaterm Configuration
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Configure nvim-tree.lua
let g:nvim_tree_highlight_opened_files = 1 
lua << EOF
 -- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup()
EOF

" Floatterm Config
nmap   <silent>   <F7>    :FloatermNew<CR>
tmap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nmap   <silent>   <F8>    :FloatermPrev<CR>
tmap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nmap   <silent>   <F9>    :FloatermNext<CR>
tmap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nmap   <silent>   <F12>   :FloatermToggle<CR>
tmap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>


" Configure trouble
lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" Configure todo-comments
lua << EOF
require("todo-comments").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
EOF

" Configure which-key
lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" Configure Auto Pairs
lua << EOF
  require('nvim-autopairs').setup{}
EOF


" Configure Telescope
lua << EOF
  local telescope = require("telescope")
  telescope.load_extension("lsp_handlers")
  telescope.setup{
  defaults = {
    path_display = {"smart"},
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
EOF

" Illuminate Config
" Time in milliseconds (default 0)
let g:Illuminate_delay = 300

" LSP Action Lightbulb
" autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

" LSP Highlight
" autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF

-- Lsp Status Configuration
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')

-- lspconfig.rust_analyzer.setup({
--   on_attach = lsp_status.on_attach,
--   capabilities = lsp_status.capabilities
-- })

-- Python LSP
-- lspconfig.pylsp.setup{}
lspconfig.pyright.setup{}

-- Rust Setup
local opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = false,
        runnables = {
            use_telescope = true
        },
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        on_attach = function(client)
            -- [[ other on_attach code ]]
            require 'illuminate'.on_attach(client)
        end,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]

require "lsp_signature".setup()
EOF

" Code navigation shortcuts
" as found in :help lsp
nnoremap <silent> <space>k     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <space>s <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gs    <cmd>Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <space>F    <cmd>lua vim.lsp.buf.formatting()<CR>
" Quick-fix
" nnoremap <silent> <space>a    <cmd>lua vim.sp.buf.code_action()<CR>
nnoremap <silent> <space>a    <cmd>CodeActionMenu<CR>
nnoremap <silent> <space>r <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <space>g <cmd>Neogit<cr>
nnoremap <silent> <space>G <cmd>terminal gitui<cr>

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF


" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

nnoremap <silent> <space>d <cmd>lua vim.diagnostic.open_float()<cr>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> go <cmd>lua vim.diagnostic.show()<cr>

" Find files using Telescope command-line sugar.
nnoremap <silent> <space>f <cmd>Telescope find_files<cr>
nnoremap <silent> <space>b <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope commands<cr>

nnoremap <silent> <space>m <cmd>MinimapToggle<cr>

nnoremap <leader>ft <cmd>NvimTreeFindFile<cr>
nnoremap <silent> <C-b> <cmd>NvimTreeToggle<cr>

nnoremap <silent> <space>S <cmd>GitGutterStageHunk<cr>
nnoremap <silent> <space>U <cmd>GitGutterUndoHunk<cr>

nnoremap <silent> <A-j> :MoveLine(1)<CR>
nnoremap <silent> <A-k> :MoveLine(-1)<CR>
vnoremap <silent> <A-j> :MoveBlock(1)<CR>
vnoremap <silent> <A-k> :MoveBlock(-1)<CR>
nnoremap <silent> <A-l> :MoveHChar(1)<CR>
nnoremap <silent> <A-h> :MoveHChar(-1)<CR>
vnoremap <silent> <A-l> :MoveHBlock(1)<CR>
vnoremap <silent> <A-h> :MoveHBlock(-1)<CR>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

"
" Statusline
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
set statusline+=\ 

" Neovide Config
" set guifont=FiraCode\ Nerd\ Font\ Mono:h8
set guifont=Mono:h8
nmap <c-=> :ZoomIn<CR>
nmap <c--> :ZoomOut<CR>

" Scroll Configuration
map <ScrollWheelUp> <C-Y>
" nmap <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>
" nmap <S-ScrollWheelDown> <C-D>

" fvim settings
if exists('g:fvim_loaded')
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
endif
