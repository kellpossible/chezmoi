local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Remap space key as the leader key
keymap("", "<Space>", "<Nop>", opts)

-- Setup which-key
local wk = require("which-key")
wk.setup()

local normal_opts = {
  mode = "n", -- NORMAL mode
}
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
  ["<C-s>"] = { "<cmd>w<CR>", "Write buffer" },
  ["<leader>"] = {
    name = "Leader",
    ["/"] = { "<cmd>HopPattern<CR>", "Hop to pattern" },
    ["1"] = { "<cmd>lua require(\"harpoon.ui\").nav_file(1)<CR>", "Harpoon 1" },
    ["2"] = { "<cmd>lua require(\"harpoon.ui\").nav_file(2)<CR>", "Harpoon 2" },
    ["3"] = { "<cmd>lua require(\"harpoon.ui\").nav_file(3)<CR>", "Harpoon 3" },
    ["4"] = { "<cmd>lua require(\"harpoon.ui\").nav_file(4)<CR>", "Harpoon 4" },
    -- a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
    a = { "<cmd>FzfLua lsp_code_actions<CR>", "Code actions" },
    A = { "<cmd>lua require('legendary').find()<CR>", "Command pallete" },
    -- b = { ":Telescope buffers<CR>", "List buffers" },
    b = { "<cmd>Fzf buffers<CR>", "List buffers" },
    B = { "<cmd>bufdo bwipeout<CR>", "Close all buffers" },
    -- B = { ":Broot<CR>", "Broot file explorer" },
    C = { "<cmd>lua setAutoCmp(false)<cr>", "Turn off autocomplete" },
    c = { "<cmd>lua setAutoCmp(true)<cr>", "Turn on autocomplete" },
    d = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Open diagnostics" },
    -- f = { ":Telescope find_files<CR>", "List files" },
    e = { "<cmd>NvimTreeFindFileToggle<CR>", "Toggle tree" },
    f = { "<cmd>FzfLua files<CR>", "List files" }, -- much faster!
    F = { "<cmd>FzfLua git_files<CR>", "List files (git)" }, -- much faster!
    g = {
      name = "Git",
      b = { "<cmd>Gitsigns blame_line<CR>", "Blame line" },
      B = { "<cmd>GitBlameToggle<CR>", "Toggle blame" },
      c = {
        name = "Conflict",
          b = { "<cmd>GitConflictChooseBoth<CR>", "Choose both" },
          n = { "<cmd>GitConflictNextConflict<CR>", "Next conflict" },
          N = { "<cmd>GitConflictChooseNone<CR>", "Choose none" },
          o = { "<cmd>GitConflictChooseOurs<CR>", "Choose ours" },
          p = { "<cmd>GitConflictPrevConflict<CR>", "Previous conflict" },
          q = { "<cmd>GitConflictListQf<CR>", "Conflict quickfix list" },
          t = { "<cmd>GitConflictChooseTheirs<CR>", "Choose theirs" },
      },
      C = { "<cmd>GitBlameOpenCommitURL<CR>", "Open commit blame URL" },
      l = {
        name = "Log/History",
        L = { "<cmd>DiffviewFileHistory %<CR>", "File history diff view"},
        l = { "<cmd>GV!<CR>", "Commits affecting this file"},
        b = { "<cmd>GV<CR>", "Commits on this branch"},
      },
      g = { "<cmd>Neogit<CR>", "Git status" },
      h = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
      n = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
      o = { "<cmd>FzfLua git_branches<CR>", "Checkout branch" },
      p = { "<cmd>Gitsigns prev_hunk<CR>", "Previous hunk" },
      r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
      R = { "<cmd>Gitsigns reset_buffer<CR>", "Reset hunk" },
      s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
      S = { "<cmd>Gitsigns stage_buffer<CR>", "Stage buffer" },
      z = { "<cmd>FzfLua git_status<CR>", "Git status fzf" },
    },
    h = { "<cmd>lua require(\"harpoon.ui\").toggle_quick_menu()<CR>", "Harpoon menu"},
    H = { "<cmd>lua require(\"harpoon.mark\").add_file()<CR>", "Harpoon add file" },
    i = { "<cmd>IndentBlanklineToggle<CR>", "Toggle indentation guides" },
    j = { "<cmd>HopWord<CR>", "Hop to word" },
    J = { "<cmd>HopChar2<CR>", "Hop to 2 characters" },
    k = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Lsp hover" },
    K = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
    l = { "<cmd>HopLine<CR>", "Hop to line" },
    L = { "<cmd>HopLineStart<CR>", "Hop to line start" },
    m = { "<cmd>lua vim.lsp.buf.format { async = true }<CR>", "Reformat buffer" },
    n = { "<cmd>noh<CR>", "No highlighting" },
    p = {
      name = "Copy file path",
      p = { "<cmd>let @\" = expand(\"%\")<CR>", "Copy relative path to register" },
      f = { "<cmd>let @\" = expand(\"%:t\")<CR>", "Copy filename to register" },
      c = { "<cmd>let @+ = expand(\"%\")<CR>", "Copy relative path to system clipboard" },
    },
    P = { "<cmd>!prettier -w %<CR>", "Reformat buffer with prettier" },
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
    R = { "<cmd>Rgr<CR>", "Repgrep find and replace" },
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
    T = { "<cmd>Trouble<CR>", "Trouble" },
    u = {
      name = "Debugging",
      b = { "<cmd>lua require(\"dap\").toggle_breakpoint()<CR>", "Toggle breakpoint" },
      c = { "<cmd>lua require(\"dap\").continue()<CR>", "Continue" },
      d = { "<cmd>lua require(\"dap\").down()<CR>", "Down in stacktrace" },
      f = { "<cmd>FzfLua dap_breakpoints<CR>", "List breakpoints" },
      i = { "<cmd>lua require(\"dap\").step_into()<CR>", "Step into" },
      n = { "<cmd>lua require(\"dap\").step_over()<CR>", "Step over" },
      o = { "<cmd>lua require(\"dap\").step_into()<CR>", "Step out" },
      p = { "<cmd>lua require(\"dap\").pause()<CR>", "Pause execution" },
      r = { "<cmd>RustDebuggables<CR>", "List Rust debuggables"},
      R = { "<cmd>lua require(\"dap\").run_to_cursor()<CR>", "Run to cursor" },
      t = { "<cmd>lua require(\"dap\").terminate()<CR>", "Terminate debug session" },
      u = { "<cmd>lua require(\"dap\").up()<CR>", "Up in stacktrace" },
    },
    w = { "<cmd>w<CR>", "Write buffer" },
    y = {
      name = "Yode",
      c = { ":YodeCreateSeditorFloating<CR>", "Create floating editor" },
    },
    z = {
      name = "Fuzzy finder",
      B = { ":FzfLua grep_curbuf<CR>", "Grep in buffer" },
      C = { ":FzfLua command_history<CR>", "List previous commands" },
      c = { ":FzfLua commands<CR>", "List commands" },
      g = { ":FzfLua grep_project<CR>", "Grep project" },
      G = { ":FzfLua live_grep<CR>", "Grep cwd" },
      h = { ":FzfLua help_tags<CR>", "List help tags" },
      k = { ":FzfLua keymaps<CR>", "List keymaps" },
      l = { ":FzfLua grep_last<CR>", "Grep previous" },
      r = { ":FzfLua oldfiles<CR>", "List recent files" },
      z = { ":FzfLua builtin<CR>", "List Fzf commands" },
    },
    Z = {
      name = "zk Notes",
      n = { "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", "New note" },
      o = { "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "List notes" },
      t = { "<Cmd>ZkTags<CR>", "Open note by tag" },
      f = { "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", "Search notes" },
    },
  },
  g = {
    name = "Goto",
    d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
    h = { "^", "Goto first (non-whitespace) character on line" },
    l = { "$", "Goto last character on line" },
    r = { "<cmd>Fzf lsp_references<CR>", "List references" },
    ["0"] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Goto document symbol" },
    W = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Goto workspace symbol" },
    x = { "<Plug>(openbrowser-smart-search)", "Open link in browser" },
  },
  s = { "<cmd>FzfLua spell_suggest<CR>", "Spelling suggestions" },
  t = {
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    "Hop to next char",
  },
  T = {
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    "Hop to previous char",
  },
  ["<F5>"] = { "<cmd>NvimTreeRefresh<CR>", "Refresh file tree" },
  ["<F6>"] = { "<cmd>NvimTreeFindFile<CR>", "Find file in tree" },
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(normal_mappings, normal_opts)

--- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-q>", "<C-w>q", opts)

-- Harpoon navigation
keymap("n", "<S-l>", "<cmd>lua require(\"harpoon.ui\").nav_next()<CR>", opts)
keymap("n", "<S-h>", "<cmd>lua require(\"harpoon.ui\").nav_prev()<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<C-A-l>", "<cmd>bn<cr>", opts)
-- keymap("n", "<C-A-h>", "<cmd>bp<cr>", opts)

-- Visual --
-- which-key
local visual_opts = {
  mode = "v", -- VISUAL mode
}
local visual_mappings = {
  ["<A-j>"] = { ":MoveBlock(1)<CR>", "Move block up" },
  ["<A-k>"] = { ":MoveBlock(-1)<CR>", "Move block down" },
  ["<A-h>"] = { ":MoveHBlock(-1)<CR>", "Move block left" },
  ["<A-l>"] = { ":MoveHBlock(1)<CR>", "Move block right" },
  ["<leader>"] = {
    ["/"] = { "<cmd>HopPattern<CR>", "Hop to pattern" },
    j = { "<cmd>HopWord<CR>", "Hop to word" },
    J = { "<cmd>HopChar2<CR>", "Hop to 2 characters" },
    l = { "<cmd>HopLine<CR>", "Hop to line" },
    L = { "<cmd>HopLineStart<CR>", "Hop to line start" },
    s = { ":sort i<CR>", "Sort selection" },
    y = {
      name = "Yode",
      c = { ":YodeCreateSeditorFloating<CR>", "Create floating editor" },
    },
  },
  a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Range code action"},
  t = {
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    "Hop to next char",
  },
  T = {
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    "Hop to previous char",
  },
  g = {
    name = "Goto",
    x = { "<Plug>(openbrowser-smart-search)", "Open link in browser" },
  },
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(visual_mappings, visual_opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep previosly yanked text when pasting
keymap("v", "p", '"_dP', opts)

-- Terminal Mode --
local terminal_mappings = {
  ["<F12>"] = { "<cmd>FloatermToggle<CR>", "Toggle terminal" },
}

wk.register(terminal_mappings, { mode = "t" })

-- Clipboard --
if vim.g.neovide then
  vim.cmd([[
    nmap <C-c> "+y
    vmap <C-c> "+y
    nmap <C-v> "+p
  ]])
else
  vim.cmd([[
    nmap <C-c> "+y
    vmap <C-c> "+y
    nmap <C-v> "+p
  ]])
end

vim.cmd([[
  inoremap <C-v> <C-r>+
  cnoremap <C-v> <C-r>+
  " use <c-r> to insert original character without triggering things like auto-pairs
  inoremap <C-r> <C-v>
]])
