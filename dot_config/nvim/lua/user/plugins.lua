local fn = vim.fn

-- Automatically install packer at startup if required
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer. Close and reopen Neovim...")
  vim.cmd [[packadd packer.nvim]]
end

-- Reload neovim whenever saving plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Don't error out on first use if packer fails
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print("Unable to load packer")
  return
end

-- Use a popup window for packer
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end
  }
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  -- Configuration --
  use "folke/neoconf.nvim"

  -- Utility Libraries --
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "nvim-neotest/nvim-nio"

  -- UI Improvements --
  use "stevearc/dressing.nvim" -- Reskin a bunch of UI elements
  use "rcarriga/nvim-notify" -- Popup notifications
  use "folke/which-key.nvim" -- Help messages for keyboard shortcuts
  use "phaazon/hop.nvim" -- Jump around document using keyboard
  use "nvim-tree/nvim-web-devicons"
  use "drzel/vim-gui-zoom" -- Zoom for neovide
  use "karb94/neoscroll.nvim" -- Smooth scroll
  -- use "noib3/nvim-cokeline" -- Bufferline
  use {
    "hoschi/yode-nvim", -- Focused code editing
    config = function()
      require('yode-nvim').setup({})
    end
  }
  use {
    "danilamihailov/beacon.nvim", -- Highlight cursor jumps
    config = function()
      -- Not required for neovide because it already has the animated cursor
      if vim.g.neovide then
        vim.g.beacon_enable = 0
      end
    end
  }
  use "ThePrimeagen/harpoon" -- Improved marks

  -- Syntax --
  use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
  }
  use "nvim-treesitter/playground"
  use "nvim-treesitter/nvim-treesitter-context"
  use "numToStr/Comment.nvim"
  use {
    "lewis6991/spellsitter.nvim",
    config = function()
      require('spellsitter').setup()
    end
  }
  use "lukas-reineke/indent-blankline.nvim"
  use "RRethy/vim-illuminate"
  -- use {
  --   "monkoose/matchparen.nvim",
  --   config = function()
  --     require('matchparen').setup()
  --   end
  -- }
  use {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  }
  use "NoahTheDuke/vim-just"
  use "Glench/Vim-Jinja2-Syntax"
  use "projectfluent/fluent.vim"
  use {
      'cameron-wags/rainbow_csv.nvim',
      config = function()
          require 'rainbow_csv'.setup()
      end,
      -- optional lazy-loading below
      module = {
          'rainbow_csv',
          'rainbow_csv.fns'
      },
      ft = {
          'csv',
          'tsv',
          'csv_semicolon',
          'csv_whitespace',
          'csv_pipe',
          'rfc_csv',
          'rfc_semicolon'
      }
  }

  -- Tools Package Manager (LSP, DAP, Linters) --
  use "williamboman/mason.nvim"

  -- Language Server Protocol (LSP) --
  use "williamboman/mason-lspconfig.nvim"
  use "neovim/nvim-lspconfig"
  use "jose-elias-alvarez/null-ls.nvim"
  use "ray-x/lsp_signature.nvim"
  use "onsails/lspkind-nvim"
  use "weilbith/nvim-code-action-menu"
  use "nvim-lua/lsp-status.nvim"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  -- use "MunifTanjim/prettier.nvim"

  -- Debug Adapter Protocol (DAP)
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"
  use "theHamsta/nvim-dap-virtual-text"

  -- Text Editing --
  use {
    "fedepujol/move.nvim", -- Move blocks of text
    config = function() require("move").setup({}) end
  }
  use "mg979/vim-visual-multi"
  use "windwp/nvim-autopairs"

  -- AI Assistants --
  use {
    "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }

  -- Orgmode --
  use {
    "nvim-orgmode/orgmode",
    config = function()
      require('orgmode').setup{}
    end 
  }


  -- Git --
  use "akinsho/git-conflict.nvim"
  use "sindrets/diffview.nvim"
  use "f-person/git-blame.nvim"
  use "lewis6991/gitsigns.nvim"
  use "junegunn/gv.vim"
  use "tpope/vim-fugitive"
  -- use "tanvirtin/vgit.nvim"
  use "TimUntersberger/neogit"
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

  -- Time Tracking --
  use "wakatime/vim-wakatime"

  -- Colorschemes --
  use "sainnhe/sonokai"
  use "rebelot/kanagawa.nvim"

  -- Writing Modes --
  use "folke/zen-mode.nvim"
  -- use "folke/twilight.nvim"

  -- Telescope --
  use "nvim-telescope/telescope.nvim"

  -- Fzf --
  use "ibhagwan/fzf-lua"

  -- Diagnostics --
  use "folke/trouble.nvim"
  -- Todo comments
  use "folke/todo-comments.nvim"

  -- Spectre --
  -- Search and replace
  use "nvim-pack/nvim-spectre"

  -- Terminal --
  use "voldikss/vim-floaterm"
  use "numToStr/FTerm.nvim"
  use "voldikss/fzf-floaterm"

  -- File Tree --
  use {
    "stevearc/oil.nvim",
    config = function() require("oil").setup() end
  }
  use "kyazdani42/nvim-tree.lua"
  -- use "ptzz/lf.vim"

  -- Autocompletion --
  -- use "hrsh7th/vim-vsnip" -- Snippet engine
  -- use "hrsh7th/vim-vsnip-integ" -- Integrations with other vim features
  use "dcampos/nvim-snippy"
  use "rafamadriz/friendly-snippets" -- Community snippets
  use "hrsh7th/nvim-cmp" -- Autocompletion engine
  -- cmp LSP completion
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  -- cmp Snippet completion
  use "hrsh7th/cmp-vsnip"
  -- cmp Path completion
  use "hrsh7th/cmp-path"
  -- cmp Buffer completion
  use "hrsh7th/cmp-buffer"
  -- See hrsh7th other plugins for more great completion sources!

  -- Utilities --
  use "chrisbra/unicode.vim" -- Unicode character pickers

  -- Inko --
  use 'inko-lang/inko.vim'

  -- Nu --
  use 'LhKipp/nvim-nu'

  -- Rust --
  use {
    "ron-rs/ron.vim", -- Rusty Object Notation Syntax
    ft = { "ron" },
  }
  use {
    "simrat39/rust-tools.nvim", -- Adds extra functionality over rust analyzer
    branch = "modularize_and_inlay_rewrite",
  }
  use "Saecki/crates.nvim"

  -- TypeScript --
  use {
    "vuki656/package-info.nvim",
    requires = {
      "MunifTanjim/nui.nvim"
    },
    config = function()
      require('package-info').setup()
    end
  }
  use { 
    "klen/nvim-test",
    config = function()
      require("nvim-test").setup()
    end
  }

  -- use {
  --   "mickael-menu/zk-nvim",
  --   config = function()
  --     require("zk").setup()
  --   end
  -- }
  -- use "renerocksai/telekasten.nvim"

  -- FlatBuffers --
  use "zchee/vim-flatbuffers"

  use "tyru/open-browser.vim"

  -- Random Fun Stuff --
  use 'eandrju/cellular-automaton.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

