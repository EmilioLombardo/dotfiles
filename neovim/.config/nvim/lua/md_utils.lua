---@diagnostic disable: param-type-mismatch

local M = {}

M.tick_box = function(undojoin)
  local undoj = ""
  if undojoin then undoj = "undojoin | " end

  -- Back up previous search pattern
  local prev_pattern = vim.fn.getreg("/")

  -- Regex stuff used:
  -- start of line: ^
  -- capture group: \(...\)
  -- any amount of whitespace: \s*
  -- literal dash: -
  -- literal brackets in the regex: \[...\]
  -- any char that isn't x: [^x]
  -- reinsert first capture group: \1
  -- literal brackets with an x between them (in the replacement text): [x]
  local success = pcall(vim.cmd, undoj .. "s/^\\(\\s*-\\s*\\)\\[[^x]\\]/\\1[x]")

  -- Restore previous search pattern
  vim.fn.setreg("/", prev_pattern)

  return success
end
M.untick_box = function(undojoin)
  local undoj = ""
  if undojoin then undoj = "undojoin | " end

  -- Back up previous search pattern
  local prev_pattern = vim.fn.getreg("/")

  -- Regex stuff used:
  -- start of line: ^
  -- capture group: \(...\)
  -- any amount of whitespace: \s*
  -- literal dash: -
  -- literal brackets in the regex: \[...\]
  -- any char that isn't a space: [^ ]
  -- reinsert first capture group: \1
  -- literal brackets with a space between them (in the replacement text): [ ]
  local success = pcall(vim.cmd, undoj .. "s/^\\(\\s*-\\s*\\)\\[[^ ]\\]/\\1[ ]")

  vim.fn.setreg("/", prev_pattern)
  -- vim.cmd('let @/ = "' .. prev_pattern .. '"')
  -- print(prev_pattern)

  return success
end

M.toggle_checkbox = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  if not M.tick_box(false) then M.untick_box(false) end
  vim.api.nvim_win_set_cursor(0, pos)
end

M.toggle_selected_checkboxes = function()
  local buffer = 0 -- current buffer
  vim.cmd"norm! " -- exit visual mode to set marks '< and '>
  local start_row = vim.api.nvim_buf_get_mark(buffer, "<")[1]
  local end_row = vim.api.nvim_buf_get_mark(buffer, ">")[1]
  local first_action_taken = false
  local action = function(_) return nil end
  local undojoin = false -- don't join the first action with the user's previous action
  for row = start_row, end_row do
    vim.cmd("norm! "..row.."gg") -- move cursor to row
    if not first_action_taken then
      if M.tick_box(undojoin) then -- first box successfully ticked
        first_action_taken = true
        undojoin = true -- all following actions should be joined together
        action = M.tick_box
      elseif M.untick_box(undojoin) then -- first box successfully UNticked
        first_action_taken = true
        undojoin = true -- all following actions should be joined together
        action = M.untick_box
      end -- Both tick_box and untick_box failed, so just go to next row
    else
      action(undojoin) -- do same action as the first successful action
    end
  end
  vim.cmd("norm! gv") -- restore the visual selection
end

return M
