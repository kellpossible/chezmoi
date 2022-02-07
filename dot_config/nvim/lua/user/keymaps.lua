local opts = {noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Remap space key as the leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup which-key
local wk = require("which-key")
wk.setup()

-- Normal Mode --
-- which-key mappings
local normal_mappings = {
  ["<A-j>"] = { "<cmd>MoveLine(1)<CR>", "Move line up" },
  ["<A-k>"] = { "<cmd>MoveLine(-1)<CR>", "Move line down" },
  ["<A-h>"] = { "<cmd>MoveHChar(-1)<CR>", "Move char left" },
  ["<A-l>"] = { "<cmd>MoveHChar(1)<CR>", "Move line right" },
  ["<C-b>"] = { "<cmd>NvimTreeToggle<CR>", "Toggle tree" },
  ["<C-=>"] = { "<cmd>ZoomIn<CR>", "Zoom in" },
  ["<C-->"] = { "<cmd>ZoomOut<CR>", "Zoom out" },
  ["<leader>"] = {
    ["/"] = { "<cmd>HopPattern<CR>", "Hop to pattern" },
    -- a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
    a = { "<cmd>CodeActionMenu<CR>", "Code action" },
    -- b = { ":Telescope buffers<CR>", "List buffers" },
    b = { ":Fzf buffers<CR>", "List buffers" },
    B = { ":Broot<CR>", "Broot file explorer" },
    C = { "<cmd>lua setAutoCmp(false)<cr>", "Turn off autocomplete" },
    c = { "<cmd>lua setAutoCmp(true)<cr>", "Turn on autocomplete" },
    -- f = { ":Telescope find_files<CR>", "List files" },
    e = { "<cmd>NvimTreeFindFileToggle<CR>", "Toggle tree" },
    f = { ":FzfLua files<CR>", "List files" }, -- much faster!
    F = { ":FzfLua git_files<CR>", "List files (git)" }, -- much faster!
    g = { "<cmd>Neogit<CR>", "Git status" },
    i = { "<cmd>IndentBlanklineToggle<CR>", "Toggle indentation guides" },
    j = { "<cmd>HopWord<CR>", "Hop to word" },
    k = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Lsp hover" },
    K = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Lsp hover" },
    l = { "<cmd>HopLine<CR>", "Hop to line" },
    L = { "<cmd>HopLineStart<CR>", "Hop to line start" },
    n = { ":noh<CR>", "No highlighting" },
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
    R = { ":Rgr<CR>", "Repgrep find and replace" },
    t = {
      name = "Telescope",
      b = { ":Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find in buffer" },
      C = { ":Telescope command_history<CR>", "List previous commands" },
      c = { ":Telescope commands<CR>", "List commands" },
      g = { ":Telescope live_grep<CR>", "Grep cwd" },
      h = { ":Telescope help_tags<CR>", "List help tags" },
      k = { ":Telescope keymaps<CR>", "List keymaps" },
      o = { ":Telescope vim_options<CR>", "List vim options" },
      r = { ":Telescope oldfiles<CR>", "List recent files" },
    },
    z = {
      name = "Fuzzy finder",
      b = { ":FzfLua grep_curbuf<CR>", "Fuzzy find in buffer" },
      C = { ":FzfLua command_history<CR>", "List previous commands" },
      c = { ":FzfLua commands<CR>", "List commands" },
      g = { ":FzfLua grep_project<CR>", "Grep project" },
      G = { ":FzfLua live_grep<CR>", "Grep cwd" },
      h = { ":FzfLua help_tags<CR>", "List help tags" },
      k = { ":FzfLua keymaps<CR>", "List keymaps" },
      z = { ":FzfLua builtin<CR>", "List Fzf commands" },
      r = { ":FzfLua oldfiles<CR>", "List recent files" },
    },
  },
  gd = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition" },
  s = { "<cmd>FzfLua spell_suggest<CR>", "Spelling suggestions" },
  t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "Hop to next char" },
  T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "Hop to previous char" },
  ["<F10>"] = { "<cmd>Floaterms<CR>", "List terminals" },
  ["<F7>"] = { "<cmd>FloatermNew<CR>", "Open new terminal" },
  ["<F8>"] = { "<cmd>FloatermPrev<CR>", "Previous terminal" },
  ["<F9>"] = { "<cmd>FloatermNext<CR>", "Next terminal" },
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(normal_mappings)


-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-q>", "<C-w>q", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- Visual --
-- which-key
local visual_mappings = {
  ["<A-j>"] = { ":MoveBlock(1)<CR>", "Move block up" },
  ["<A-k>"] = { ":MoveBlock(-1)<CR>", "Move block down" },
  ["<A-h>"] = { ":MoveHBlock(-1)<CR>", "Move block left" },
  ["<A-l>"] = { ":MoveHBlock(1)<CR>", "Move block right" },
  ["<leader>"] = {
    ["/"] = { "<cmd>HopPattern<CR>", "Hop to pattern" },
    j = { "<cmd>HopWord<CR>", "Hop to word" },
    l = { "<cmd>HopLine<CR>", "Hop to line" },
    L = { "<cmd>HopLineStart<CR>", "Hop to line start" },
    s = { ":sort i<CR>", "Sort selection" },
  },
  t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "Hop to next char" },
  T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "Hop to previous char" },
  ["<F7>"] = { "<cmd>FloatermNew<CR>", "Open new terminal" },
  ["<F8>"] = { "<cmd>FloatermPrev<CR>", "Previous terminal" },
  ["<F9>"] = { "<cmd>FloatermNext<CR>", "Next terminal" },
  ["<F10>"] = { "<cmd>Floaterms<CR>", "List terminals" },
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(visual_mappings, { mode = "v" })

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep previosly yanked text when pasting
keymap("v", "p", "\"_dP", opts)

-- Terminal Mode --
local terminal_mappings = {
  ["<F7>"] = { "<cmd>FloatermNew<CR>", "Open new terminal" },
  ["<F8>"] = { "<cmd>FloatermPrev<CR>", "Previous terminal" },
  ["<F9>"] = { "<cmd>FloatermNext<CR>", "Next terminal" },
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(terminal_mappings, { mode = "t" })


-- Clipboard --
-- Copy
-- keymap("v", "<leader>y", "\"+y", opts)
-- keymap("n", "<leader>Y", "\"+yg_", opts)
-- keymap("n", "<leader>y", "\"+y", opts)
-- keymap("n", "<leader>yy", "\"+yy", opts)
-- Paste
-- keymap("n", "<leader>p", "\"+p", opts)
-- keymap("n", "<leader>P", "\"+P", opts)
-- keymap("v", "<leader>p", "\"+p", opts)
-- keymap("v", "<leader>p", "\"+P", opts)

vim.cmd [[
  nmap <c-c> "+y
  vmap <c-c> "+y
  nmap <c-v> "+p
  inoremap <c-v> <c-r>+
  cnoremap <c-v> <c-r>+
  " use <c-r> to insert original character without triggering things like auto-pairs
  inoremap <c-r> <c-v>
]]
