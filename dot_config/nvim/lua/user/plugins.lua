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

  -- Utility Libraries --
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- UI Improvements --
  use "stevearc/dressing.nvim" -- Reskin a bunch of UI elements
  use "rcarriga/nvim-notify" -- Popup notifications
  use "folke/which-key.nvim" -- Help messages for keyboard shortcuts
  use "phaazon/hop.nvim" -- Jump around document using keyboard
  use "kyazdani42/nvim-web-devicons"
  use "drzel/vim-gui-zoom" -- Zoom for neovide
  use "noib3/nvim-cokeline" -- Bufferline
  use {
    "hoschi/yode-nvim", -- Focused code editing
    config = function()
      require('yode-nvim').setup({})
    end
  }

  -- Syntax --
  use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
  }
  use "nvim-treesitter/playground"
  use "romgrk/nvim-treesitter-context"
  use "numToStr/Comment.nvim"
  use {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end
  }
  use "lukas-reineke/indent-blankline.nvim"
  use "RRethy/vim-illuminate"
  use {
    "monkoose/matchparen.nvim",
    config = function()
      vim.g.loaded_matchparen = 1
      require('matchparen').setup()
    end
  }

  -- Language Server Protocol (LSP) --
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "jose-elias-alvarez/null-ls.nvim"
  use "ray-x/lsp_signature.nvim"
  use "onsails/lspkind-nvim"
  use "weilbith/nvim-code-action-menu"
  use "nvim-lua/lsp-status.nvim"

  -- Text Editing --
  use "fedepujol/move.nvim" -- Move blocks of text
  use "mg979/vim-visual-multi"
  use "windwp/nvim-autopairs"

  -- Git --
  use "TimUntersberger/neogit"
  use "lewis6991/gitsigns.nvim"

  -- Colorschemes --
  use "sainnhe/sonokai"

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
  use "kyazdani42/nvim-tree.lua"
  -- use "ptzz/lf.vim"

  -- Autocompletion --
  use "hrsh7th/vim-vsnip" -- Snippet engine
  use "hrsh7th/vim-vsnip-integ" -- Integrations with other vim features
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

  -- Rust --
  use {
    "ron-rs/ron.vim", -- Rusty Object Notation Syntax
    ft = { "ron" },
  }
  use "simrat39/rust-tools.nvim" -- Adds extra functionality over rust analyzer
  use "Saecki/crates.nvim"

  use {
    "mickael-menu/zk-nvim",
    config = function()
      require("zk").setup()
    end
  }
  -- use "renerocksai/telekasten.nvim"

  use "tyru/open-browser.vim"
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

