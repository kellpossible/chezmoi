" Some great ideas for vim configuration here
" https://www.youtube.com/watch?v=434tljD-5C8

call plug#begin()

" Utility Libraries
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'romgrk/nvim-treesitter-context'

Plug 'NoahTheDuke/vim-just'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

" LSP Symbols Outline
" Plug 'simrat39/symbols-outline.nvim'

" Themes
Plug 'tanvirtin/monokai.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/everforest'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

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
Plug 'Saecki/crates.nvim'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'

Plug 'glepnir/dashboard-nvim'

Plug 'folke/todo-comments.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'lewis6991/gitsigns.nvim'
" Find and replace Global
Plug 'nvim-pack/nvim-spectre'
" Find and replace Local
" Plug 'kqito/vim-easy-replace'
Plug 'folke/which-key.nvim'

" Unicode
Plug 'chrisbra/unicode.vim'

" File Tree
" Plug 'saviocmc/nvim-tree.lua', { 'branch': 'restore-feat/highlight-git-ignored-files' }
" Plug 'luukvbaal/nnn.nvim'
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'skyuplam/broot.nvim'
" Plug 'rbgrouleff/bclose.vim'

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
Plug 'weilbith/nvim-code-action-menu'
" TODO waiting for PR:
" https://github.com/weilbith/nvim-code-action-menu/pull/34
" Plug 'filtsin/nvim-code-action-menu'

" Action lightbulb
" Plug 'kosayoda/nvim-lightbulb'

Plug 'ray-x/lsp_signature.nvim'

" Matching closing brackets
Plug 'windwp/nvim-autopairs'

" Highlight matching parenthesis/brackets
Plug 'monkoose/matchparen.nvim'

" Floating Terminal
Plug 'voldikss/vim-floaterm'

" Highlight variables
Plug 'RRethy/vim-illuminate'

" Rusty Object Notation Syntax
Plug 'ron-rs/ron.vim'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Code formatting without lsp
Plug 'mhartington/formatter.nvim'

" Zen Modes
Plug 'folke/zen-mode.nvim'
Plug 'Pocco81/TrueZen.nvim'

" Hop easy motion
Plug 'phaazon/hop.nvim'

" Marks
Plug 'chentau/marks.nvim'

" Org Modes
Plug 'nvim-orgmode/orgmode'
Plug 'nvim-neorg/neorg'

"Clipboard neoclip
Plug 'AckslD/nvim-neoclip.lua'

call plug#end()

" Open urls, workaround because netrw isn't working...
nmap gx yiW:!xdg-open <cWORD><CR> <C-r>" & <CR><CR>

" Use regular movement keys for soft wrapped lines.
" source: https://stackoverflow.com/a/21000307/446250
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" system clipboard
nmap <c-c> "+y
vmap <c-c> "+y
nmap <c-v> "+p
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <c-r> <c-v>

" Configure matchparen
" Disable default matchparen
let g:loaded_matchparen = 1
lua require('matchparen').setup()

" Configure minimap
let g:minimap_auto_start = 0
let g:minimap_highlight_search = 1
let g:minimap_git_colors = 1

" Configure dashboard
let g:dashboard_default_executive = "telescope"
let g:dashboard_custom_header = [
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\]

" Configure comment
lua require('Comment').setup()

" Configure marks
lua << EOF
  require('marks').setup { 
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    -- builtin_marks = { ".", "<", ">", "^" },
    builtin_marks = {},
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = false,
    -- how often (in ms) to redraw signs/recompute mark positions. 
    -- higher values will have better performance but may cause visual lag, 
    -- while lower values may cause performance penalties. default 150.
    refresh_interval = 250,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be either a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {},
    -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    -- default virt_text is "".
    -- bookmark_0 = {
    --  sign = "⚑",
    --  virt_text = "hello world"
    --},
    mappings = {}
  }
EOF
" Configure neogit
lua require('neogit').setup()

" Configure Zen modes
lua << EOF
  require('zen-mode').setup {
    window = {
      width = 140
    }
  }
EOF
lua require('true-zen').setup()

" Tree Sitter Configuration
lua << EOF
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
      url = 'https://github.com/milisims/tree-sitter-org',
      revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
      files = {'src/parser.c', 'src/scanner.cc'},
    },
    filetype = 'org',
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  indent = {
    enable = true
  }
}
EOF
" Use treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99 " Ensure everything is unfolded by default

" General Editor Settings
syntax on
set mouse=a
set number
set expandtab
set shiftwidth=4
set tabstop=4
set list
set listchars=tab:▸\ ,trail:· " Show things that I normally don't want
set termguicolors
 " trigger `autoread` when files changes on disk
set autoread
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
" autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Window Title
function SetTitleString()
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

" Color Schemes
" colorscheme monokai_pro

" tokyo night scheme
" colorscheme tokyonight
" let g:tokyonight_style = "night"

" sonokai scheme
colorscheme sonokai

" everforest scheme
" Designed to work well with redshift
" set background=dark
" let g:everforest_background = 'hard'
" colorscheme everforest

" Reselect selection after indentation
vnoremap < <gv
vnoremap > >gv

" Allow gf to open non-existent files
map gf :edit <cfile><cr>

" Floaterm Configuration
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_opener = 'edit'

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Configure nnn
" tnoremap <silent> <C-b> <cmd>NnnExplorer<CR>
" nnoremap <silent> <C-B> <cmd>NnnExplorer %:p:h<CR>
" lua << EOF
"   require("nnn").setup({
"     explorer = {
"       cmd = "nnn -G",       -- command overrride (-F1 flag is implied, -a flag is invalid!)
"       width = 24,        -- width of the vertical split
"       side = "topleft",  -- or "botright", location of the explorer window
"       session = "",      -- or "global" / "local" / "shared"
"       tabs = true,       -- seperate nnn instance per tab
"     },
"     picker = {
"         cmd = "nnn -G",
"         session = "shared",
"     },
"     replace_netrw = "picker",
"     window_nav = "<C-l>"
"   })
" EOF

" Configure nvim-tree.lua
nnoremap <leader>ft <cmd>NvimTreeFindFile<cr>
nnoremap <silent> <C-b> <cmd>NvimTreeToggle<cr>
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_git_hl = 1
lua << EOF
  require'nvim-tree'.setup {
    git = {
      ignore = false,
      enable = true,
    },
    trash = {
      cmd = "trash",
      require_confirm = true,
    }
  }
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


" Configure gitsigns
lua require('gitsigns').setup()
nnoremap <silent> <space>h <cmd>Gitsigns preview_hunk<CR>

" Configure indent-blankline
lua << EOF
  require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = false,
    filetype_exclude = { "dashboard" },
  }
EOF
" Configure formatter
lua << EOF
  require("formatter").setup({
    filetype = {
      json = {
        function()
          return {
            exe = "jq",
            stdin = true
          }
        end
      }
    }
  })
EOF
nnoremap <silent> <leader>F <cmd>:Format<CR>

" Configure trouble
lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" Configure orgmode
lua require('orgmode').setup()

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
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local fb_actions = require("telescope._extensions.file_browser.actions")
  local telescope = require("telescope")
  telescope.load_extension("lsp_handlers")
  telescope.load_extension("neoclip")
  telescope.setup{
  defaults = {
    -- Default configuration for telescope goes here:
    layout_strategy = "horizontal",
    layout_config = {
      height = 0.5,
    },
    path_display = {
      truncate = 15,
    },
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
    -- https://gitter.im/nvim-telescope/community?at=6113b874025d436054c468e6 Fabian David Schmidt
    buffers = {
        mappings = {
          n = {
            ["<C-d>"] = actions.delete_buffer,
          },
          i = {
            ["<C-d>"] = actions.delete_buffer,
          }
        },
    },
    find_files = {
      on_input_filter_cb = function(prompt)
        local find_colon = string.find(prompt, ":")
        if find_colon then
          local ret = string.sub(prompt, 1, find_colon - 1)
          vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local lnum = tonumber(prompt:sub(find_colon + 1))
            if type(lnum) == "number" then
              local win = picker.previewer.state.winid
              local bufnr = picker.previewer.state.bufnr
              local line_count = vim.api.nvim_buf_line_count(bufnr)
              vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
            end
          end)
          return { prompt = ret }
        end
      end,
      attach_mappings = function()
        actions.select_default:enhance({
          post = function()
            -- if we found something, go to line
            local prompt = action_state.get_current_line()
            local find_colon = string.find(prompt, ":")
            if find_colon then
              local lnum = tonumber(prompt:sub(find_colon + 1))
              vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            end
          end,
        })
        return true
      end,
    },
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

" Configure rust cargo crates
lua require('crates').setup()

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF

-- Lsp Status Configuration
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')

lspconfig.texlab.setup{}

-- lspconfig.rust_analyzer.setup({
--   on_attach = lsp_status.on_attach,
--   capabilities = lsp_status.capabilities
-- })

-- Python LSP
-- lspconfig.pylsp.setup{}
lspconfig.pyright.setup{}

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
                procMacro = {
                    -- ignored = {
                    --     ["async-trait"] = "async_trait"
                    -- }
                },
            }
        },
        capabilities = capabilities,
    },
}

require('rust-tools').setup(opts)

require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
        -- ["../path/relative/to/file.yml"] = "/.github/workflows/*"
        -- ["/path/from/root/of/project"] = "/.github/workflows/*"
      },
    },
  }
}

vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]

require "lsp_signature".setup()
EOF

" LSP Shortcuts
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

" Spelling
nnoremap <silent> <space>p <cmd>Telescope spell_suggest<cr>

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
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
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
    { name = 'crates' },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

function setAutoCmp(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
  end
end
EOF

nnoremap <silent> <space>c <cmd>lua setAutoCmp(true)<cr>
nnoremap <silent> <space>C <cmd>lua setAutoCmp(false)<cr>


"Setup neoclip
lua require('neoclip').setup()
nnoremap <silent> <space>v <cmd>Telescope neoclip<cr>
vnoremap <silent> <space>v <cmd>Telescope neoclip<cr>

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

" No Highlight
nnoremap <silent> <space>n <cmd>noh<cr>

" Hop Configuration
lua << EOF
require('hop').setup { 
  keys = 'etovxqpdygfblzhckisuran',
  jump_on_sole_occurrence = false,
}
vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
EOF
nnoremap <silent> <space>/ <cmd>HopPattern<cr>
vnoremap <silent> <space>/ <cmd>HopPattern<cr>
nnoremap <silent> <space>j <cmd>HopWord<cr>
vnoremap <silent> <space>j <cmd>HopWord<cr>
nnoremap <silent> <space>L <cmd>HopLineStart<cr>
vnoremap <silent> <space>L <cmd>HopLineStart<cr>
nnoremap <silent> <space>l <cmd>HopLine<cr>
vnoremap <silent> <space>l <cmd>HopLine<cr>

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Highlight when yanking
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

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

" neovide Config
" set guifont=FiraCode\ Nerd\ Font\ Mono:h8
set guifont=Mono:h8
let g:neovide_window_position_animation_length = 0
let g:neovide_window_floating_opacity = 1
let g:neovide_window_floating_blur = 0
let g:neovide_floating_blur = 0
let g:neovide_floating_opacity = 1

" Zoom In and Out
nmap <c-=> :ZoomIn<CR>
nmap <c--> :ZoomOut<CR>

" Scroll Configuration
map <ScrollWheelUp> <C-Y>
" nmap <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>

" fvim settings
if exists('g:fvim_loaded')
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
endif

" Run chezmoi apply when saving dotfiles
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
