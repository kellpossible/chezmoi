local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  print("Error while loading treesitter configurations")
  return
end

configs.setup {
  ensure_installed = "all",
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    -- additional_vim_regex_highlighting = {"org"},
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- treesitter-context configuration --
local status_ok, treesitter_context = pcall(require, "treesitter-context")
if not status_ok then
  print("Error loading treesitter-context")
  return
end

treesitter_context.setup {
  patterns = {
    rust = {
      "enum_item",
      "struct_item",
    }
  }
}

local status_ok, install = pcall(require, "nvim-treesitter.install")
if not status_ok then
  print("Error while loading treesitter install")
  return
end

install.compilers = { "clang" }
