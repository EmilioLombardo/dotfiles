-- [[ NAVIGATION ]] {{{

-- Space in normal/visual mode doesn't move cursor
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- j and k move one *visual* line (for dealing with word wrap)
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ctrl-u/d and n/N centre the cursor
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', 'n', '<cmd>norm! nzvzz<cr>', { noremap = true })
vim.keymap.set('n', 'N', '<cmd>norm! Nzvzz<cr>', { noremap = true })

-- ctrl-e and ctrl-y move two rows at a time instead of one
vim.keymap.set('n', '<c-e>', "v:count == 0 ? '2<c-e>' : '<c-e>'", { expr = true, silent = true })
vim.keymap.set('n', '<c-y>', "v:count == 0 ? '2<c-y>' : '<c-y>'", { expr = true, silent = true })

-- Open file explorer
vim.keymap.set('n', '<leader>e', "<cmd>Explore<cr>", { desc = "Open file explorer (netrw)" })
vim.keymap.set('n', '<leader>E', "<cmd>Rexplore<cr>", { desc = "Toggle between last edited file and last netrw location" })

-- When in file explorer: use the same keymap to close file explorer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(event)
    vim.keymap.set('n', '<leader>e', "<cmd>Rexplore<cr>",
      { desc = "Return to last edited file", buffer = event.buf, })
  end,
})


-- }}}

-- [[ YANK & PASTE ]] {{{
-- x cuts to black hole register
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
-- Paste over selection without overriding text in register
vim.keymap.set('x', '<leader>p', '"_xP')
-- }}}

-- [[ MODE STUFF ]] {{{
-- jj to quickly exit insert mode
vim.keymap.set('i', 'jj', '<esc>')
vim.keymap.set('i', 'Jj', '<esc>')
vim.keymap.set('i', 'JJ', '<esc>')
-- ESC in a terminal buffer exits insert mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<c-æ>', '<C-\\><C-n>')
-- }}}

-- [[ TEXT EDITING ]] {{{

-- shortcut for adding semicolon to end of line
vim.keymap.set('n', '<leader>;', 'A;<esc>')

-- <leader>o is like o, but adds an additional blank line below
vim.keymap.set('n', '<leader>o', 'o<esc>0"_Dk_o<esc>0"_cc')
-- <leader>O is like O, but adds an additional blank line above
vim.keymap.set('n', '<leader>O', 'O<esc>0"_Dj_O<esc>0"_cc')
-- Main use case: when cursor is on a blank line, <leader>o will add a blank
-- line above and below and enter insert mode.

-- ctrl-k/j adds empty line above/below current line
vim.keymap.set('n', '<c-k>', 'O<esc>0"_Dj_')
vim.keymap.set('n', '<c-j>', 'o<esc>0"_Dk_')
-- }}}

-- [[ DIAGNOSTICS ]] {{{

-- jump to next/previous diagnostic
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({count = -1, float = true}) end)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({count = 1, float = true}) end)

-- Show float menu with diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Open diagnostic float menu" })

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- }}}

-- [[ OTHER ]] {{{

-- Resize windows by three units at a time
vim.keymap.set('n', '<M-<>', '<c-w>3<')
vim.keymap.set('n', '<M->>', '<c-w>3>')
vim.keymap.set('n', '<M-+>', '<c-w>3+')
vim.keymap.set('n', '<M-->', '<c-w>3-')
-- To achieve same effect on a Norwegian Mac keyboard:
vim.keymap.set('n', '≤', '<c-w>3<')
vim.keymap.set('n', '≥', '<c-w>3>')
vim.keymap.set('n', '±', '<c-w>3+')
vim.keymap.set('n', '–', '<c-w>3-')

-- Refresh LuaSnip snippets
vim.keymap.set('n', '<Leader>L', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>')

--[[
-- Show treesitter capture group for textobject under cursor.
vim.keymap.set('n', "˛",--"<M-h>",
  function()
    local result = vim.treesitter.get_captures_at_cursor(0)
    print(vim.inspect(result))
  end,
  { silent = false }
)
]]

-- }}}

-- vim: foldmethod=marker nowrap ts=2 sts=2 sw=2 et
