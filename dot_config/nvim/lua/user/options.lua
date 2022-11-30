-- :help options
local options = {
  autoread = true, -- trigger `autoread` when files changes on disk
  expandtab = true,  -- in Insert mode: Use the appropriate number of spaces to insert a <Tab>
  list = true, -- strings to use in 'list' mode and for the :list command
  listchars = "tab:▸ ,trail:·", -- show things that I normally don't want
  mouse = "a", -- enables mouse support (in all modes)
  number = true, -- precede each line with its line number
  pumheight = 10, -- popup menu height
  scrolloff = 5, -- minimal number of screen lines to keep above and below the cursor
  shiftwidth = 4, -- number of spaces to use for each step of (auto)indent
  sidescrolloff = 5, -- the minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set
  cmdheight = 0, -- Number of screen lines to use for the command-line
  tabstop = 4, -- number of spaces that a <Tab> in the file counts for
  termguicolors = true, -- enables 24-bit RGB color in the TUI
  wrap = true, -- line wrapping
  swapfile = false, -- use a swap file for the buffer
  backup = false, -- create a backup file for the buffer
  foldlevelstart = 99, -- sets 'foldlevel' when starting to edit another buffer in a window
  -- GUI --
  guifont = "FiraCode Nerd Font Mono:h12",
  -- guifont = "DejaVuSansMono Nerd Font Mono:h8",
  -- guifont = "Mono:h8",
  -- guifont = "Hack Nerd Font:h8",
  -- guifont = "RobotoMono Nerd Font:h8",
  -- guifont = "SauceCodePro Nerd Font:h8",
  -- guifont = "JetBrainsMono Nerd Font:h8"
  -- TODO: linebreak for markdown files
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Any append options
vim.opt.iskeyword = vim.opt.iskeyword + "-" -- Keywords are used in searching and recognizing with many commands
