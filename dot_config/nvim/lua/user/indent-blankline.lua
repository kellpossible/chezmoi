require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = false,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = { 
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
  },
}
