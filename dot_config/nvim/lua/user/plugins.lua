return {
  -- Configuration --
  "folke/neoconf.nvim",

  -- Tools Package Manager (LSP, DAP, Linters) --
  "williamboman/mason.nvim",
  
  -- Utility Libraries --
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
  "nvim-neotest/nvim-nio",
  
  -- UI Improvements --
  "stevearc/dressing.nvim", -- Reskin a bunch of UI elements
  "rcarriga/nvim-notify", -- Popup notifications
  "folke/which-key.nvim", -- Help messages for keyboard shortcuts
  {
    "phaazon/hop.nvim",
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
      jump_on_sole_occurrence = false,
    }
  }, -- Jump around document using keyboard
  "nvim-tree/nvim-web-devicons",
  "drzel/vim-gui-zoom", -- Zoom for neovide
  "karb94/neoscroll.nvim", -- Smooth scroll
  -- use "noib3/nvim-cokeline" -- Bufferline
  {
    "danilamihailov/beacon.nvim", -- Highlight cursor jumps
    config = function(plugin)
      require('beacon').setup()
      -- Not required for neovide because it already has the animated cursor
      if vim.g.neovide then
        vim.g.beacon_enable = 0
      end
    end
  },
  {
    "ThePrimeagen/harpoon",-- Improved marks
    opts = {
      global_settings = {
        -- set marks specific to each git branch inside git repository
        mark_branch = true,
      },
      menu = {
        width = 80,
      },
    }
  },
  -- Telescope --
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local action_state = require("telescope.actions.state")
      local actions = require("telescope.actions")
      -- local fb_actions = require("telescope._extensions.file_browser.actions")
      local telescope = require("telescope")
      -- telescope.load_extension("lsp_handlers")
      -- telescope.load_extension("neoclip")
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
              sort_lastused = true,
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
    end
  },
  -- Fzf --
  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_opts = {
        -- options are sent as `<left>=<right>`
        -- set to `false` to remove a flag
        -- set to '' for a non-value flag
        -- for raw args use `fzf_args` instead
        ['--ansi']        = '',
        ['--prompt']      = '> ',
        ['--info']        = 'inline',
        ['--height']      = '100%',
        ['--layout']      = 'reverse',
      },
      git = {
        status = {
          preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
      },
    }
  },

  -- Syntax --
  {
      "nvim-treesitter/nvim-treesitter",
      init = function(plugin)
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end,
      build = function()
          require("nvim-treesitter.install").update({ with_sync = true })()
      end,
      opts = {
        ensure_installed = "all",
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "csv" }, -- List of parsers to ignore installing
        autopairs = {
          enable = true,
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = function(lang, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 5000
            -- local max_filesize = 100 * 1024 -- 100 KB
            -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            -- if ok and stats and stats.size > max_filesize then
            --     return true
            -- end
          end,
          -- additional_vim_regex_highlighting = {"org"},
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      },
      config = function(plugin, opts)
        -- require("nvim-treesitter.install").compilers = { "gcc" }
        require("nvim-treesitter.configs").setup(opts)
      end
  },
  "nvim-treesitter/playground",
  { 
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 6,
      min_window_height = 20,
      multiline_threshold = 3,
      patterns = {
        rust = {
          "enum_item",
          "struct_item",
        }
      },
    }
  },
  "numToStr/Comment.nvim",
  { "lewis6991/spellsitter.nvim", config = true },
  "lukas-reineke/indent-blankline.nvim",
  -- use "RRethy/vim-illuminate"
  -- -- use {
  -- --   "monkoose/matchparen.nvim",
  -- --   config = function()
  -- --     require('matchparen').setup()
  -- --   end
  -- -- }
  { "kylechui/nvim-surround", config = true },
  "NoahTheDuke/vim-just",
  -- use "Glench/Vim-Jinja2-Syntax"
  "projectfluent/fluent.vim",
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    },
    cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
    }   
  },


  -- Language Server Protocol (LSP) --
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "ray-x/lsp_signature.nvim",
  "onsails/lspkind-nvim",
  "nvim-lua/lsp-status.nvim",
  'nvim-lualine/lualine.nvim',
  -- use "MunifTanjim/prettier.nvim"

  -- Debug Adapter Protocol (DAP)
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",

  -- Language Specific --
  -- Rust --
  {
    "ron-rs/ron.vim", -- Rusty Object Notation Syntax
    ft = { "ron" },
  },
  {
    "simrat39/rust-tools.nvim", -- Adds extra functionality over rust analyzer
    -- branch = "modularize_and_inlay_rewrite",
  },
  "Saecki/crates.nvim",
  -- Flatbuffers --
  -- "zchee/vim-flatbuffers",

  -- Text Editing --
  { "fedepujol/move.nvim", config = true }, -- Move blocks of text
  { "mg979/vim-visual-multi" },
  "windwp/nvim-autopairs",

  -- Time Tracking --
  "wakatime/vim-wakatime",

  -- Colorschemes --
  "sainnhe/sonokai",
  "rebelot/kanagawa.nvim",

  -- Writing Modes --
  "folke/zen-mode.nvim",
  
  -- Terminal --
  "voldikss/vim-floaterm",
  "numToStr/FTerm.nvim",
  "voldikss/fzf-floaterm",
  
    -- Autocompletion --
  -- use "hrsh7th/vim-vsnip" -- Snippet engine
  -- use "hrsh7th/vim-vsnip-integ" -- Integrations with other vim features
  "dcampos/nvim-snippy",
  "rafamadriz/friendly-snippets", -- Community snippets
  "hrsh7th/nvim-cmp", -- Autocompletion engine
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-buffer",
  -- See hrsh7th other plugins for more great completion sources!
  
  -- File Tree --
  {
    "stevearc/oil.nvim",
    config = true
  },
  "kyazdani42/nvim-tree.lua",

  -- Diagnostics --
  "folke/trouble.nvim",
  -- Todo comments
  "folke/todo-comments.nvim",
  
  -- Git --
  "akinsho/git-conflict.nvim",
  "sindrets/diffview.nvim",
  "f-person/git-blame.nvim",
  "lewis6991/gitsigns.nvim",
  "junegunn/gv.vim",
  "tpope/vim-fugitive",
  -- use "tanvirtin/vgit.nvim"
  "TimUntersberger/neogit",
  -- use {
  --   "pwntester/octo.nvim",
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-telescope/telescope.nvim',
  --     'kyazdani42/nvim-web-devicons',
  --   },
  --   config = function ()
  --     require("octo").setup()
  --   end
  -- }

  -- Miscelaneous --
  "tyru/open-browser.vim",
  "chrisbra/unicode.vim", -- Unicode character pickers
}
