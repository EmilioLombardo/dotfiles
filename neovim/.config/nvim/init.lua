require("config.lazy")
require("keymaps")

-- [[ VIM OPTIONS ]]

-- TABULATION
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
--vim.o.autoindent = true

-- AESTHETICS
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true -- Enable 24-bit colour
vim.o.showmode = false -- Don't show mode in command line (e.g. "-- INSERT --")
vim.o.cursorline = true -- Highlight line containing cursor
-- Wrapped lines align with same indent level as original line
vim.o.breakindent = true
vim.g.netrw_winsize = 25 -- Set window width for netrw (file explorer)
vim.g.netrw_banner = 0 -- Disable help banner for netrw (file explorer)

-- SEARCH
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- No search highlight
vim.o.hlsearch = false

-- FOLDS
vim.o.foldmethod = "syntax"
vim.o.foldlevel = 2

-- OTHER
vim.o.updatetime = 1000  -- see :help updatetime
vim.o.mouse = 'a'
vim.o.undofile = true  -- Save undo history
-- Set completeopt to have a better completion experience
--    menuone: show the menu even with only one match
--    noselect: don't automatically select an item in the menu
vim.o.completeopt = 'menuone,noselect'

-- [[ AUTOCOMMANDS ]]

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Always enter insert mode when entering the neovim terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.opt.buftype:get() == "terminal" then
      vim.cmd(":startinsert")
    end
  end
})


-- [[ CUSTOM COMMANDS ]]

-- Compare edited buffer with file saved on disk
vim.cmd [[ command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
       \ | diffthis | wincmd p | diffthis ]]

-- Shortcuts for compiling C++ project (for the university course TDT4102 at NTNU)
vim.cmd [[ command! TDT4102compile w | term meson compile -C builddir && ./builddir/program ]]
vim.cmd [[ command! TDT4102run w | term ./builddir/program ]]



-- vim: ts=2 sts=2 sw=2 et foldmethod=indent nowrap
