require("ibl").setup {
  indent = {
    tab_char = "▎"
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
  exclude = {
    filetypes = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
    },
    buftypes = {
      "terminal", "nofile"
    }
  }
}
