-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

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
-- add relative line numbers to netrw
vim.g.netrw_bufsettings="noma nomod nu nobl nowrap ro rnu"
vim.o.winborder = "rounded" -- border style for all floating windows

-- SEARCH
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- No search highlight
vim.o.hlsearch = false
vim.opt.path:append("**") -- use :find to search in subdirectories as well

-- FOLDS
vim.o.foldmethod = "syntax"
vim.o.foldlevelstart = 2

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

-- Hack to make Telescope support new option vim.o.winborder
-- Shouldn't be needed once this pull request is merged:
-- https://github.com/nvim-lua/plenary.nvim/pull/649
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    vim.opt_local.winborder = "none"
    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt_local.winborder = "rounded"
      end,
    })
  end,
})

-- Hack to remove border from backdrop of Lazy's floating window
-- Shouldn't be needed once this issue is resolved:
-- https://github.com/folke/lazy.nvim/issues/1951
vim.api.nvim_create_autocmd("FileType", {
	desc = "User: fix backdrop for lazy window",
	pattern = "lazy_backdrop",
	group = vim.api.nvim_create_augroup("lazynvim-fix", { clear = true }),
	callback = function(ctx)
		local win = vim.fn.win_findbuf(ctx.buf)[1]
		vim.api.nvim_win_set_config(win, { border = "none" })
	end,
})

-- [[ CUSTOM COMMANDS ]]

-- Compare edited buffer with file saved on disk
vim.api.nvim_create_user_command("DiffOrig",
  [[vert new | set buftype=nofile | read ++edit # | 0d_ |
  diffthis | wincmd p | diffthis]], {})

-- Shortcuts for compiling C++ project (for the university course TDT4102 at NTNU)
vim.cmd [[ command! TDT4102compile w | term meson compile -C builddir && ./builddir/program ]]
vim.cmd [[ command! TDT4102run w | term ./builddir/program ]]



-- vim: ts=2 sts=2 sw=2 et foldmethod=indent nowrap
