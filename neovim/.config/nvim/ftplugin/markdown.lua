vim.wo.wrap = true
vim.wo.linebreak = true

-- TODO: Make my custom keymap for <c-e> and <c-y> not apply to markdown files,
-- so they scroll only 1 instead of 2 lines.

-- This here does not work, because the custom keymaps aren't defined by this
-- point, so there is nothing to delete, and it produces and error.
-- vim.keymap.del("n", "<c-e>", { buffer = 0 })
-- vim.keymap.del("n", "<c-y>", { buffer = 0 })
