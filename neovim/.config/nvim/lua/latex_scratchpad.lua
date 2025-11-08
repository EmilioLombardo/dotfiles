---Open a scratchpad for editing LaTeX
---@param paste_visual boolean
---@param close_and_paste_keymap string
local function latex_scratchpad(paste_visual, close_and_paste_keymap)

  -- Create the scratchpad buffer and set options
  local buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf_id })
  vim.api.nvim_set_option_value("filetype", "tex", { buf = buf_id })
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf_id })

  -- local width = math.floor(vim.o.columns * 0.80)
  -- local height = 10
  -- local col = math.floor((vim.o.columns - width) / 2)
  -- -- local row = math.floor((vim.o.lines - height) / 2)
  -- local row = math.floor(vim.o.lines - height - 4) -- align to bottom of editor

  local parent_win_width = vim.api.nvim_win_get_width(0)
  local parent_win_height = vim.api.nvim_win_get_height(0)
  local width = math.floor(parent_win_width * 0.8)
  local height = math.min(10, math.floor(parent_win_height * 0.8) - 2)
  local col = math.floor((parent_win_width - width)/2)
  local row = vim.api.nvim_win_get_height(0) - height - 2 -- align to bottom of window
  height = math.max(1, height)

  local centered_window_opts = {

    -- relative = "editor",
    col = col,
    row = row,

    relative = "win",
    -- bufpos = {row, col},

    width = width,
    height = height,
    border = vim.opt.winborder:get() or "rounded",
    title = " LaTeX ",
    title_pos = "right",
    footer = " " .. close_and_paste_keymap .. " to close and insert contents ",
    footer_pos = "center",
  }

  -- local at_cursor_window_opts = {
    -- relative = "cursor",
    -- col = 0,
    -- row = 1,
    -- width = 85,
    -- height = 6,
    -- border = vim.opt.winborder:get() or "rounded",
    -- title = " LaTeX ",
    -- title_pos = "right",
    -- footer = " " .. close_and_paste_keymap .. " to close and insert contents ",
    -- footer_pos = "center",
  -- }

  -- Capture visual selection to "v before opening scratchpad
  local old_reg_v
  if paste_visual then
    old_reg_v = vim.fn.getreg("v")
    vim.cmd('normal! gv"vy')
  end

  -- Open scratchpad window
  vim.api.nvim_open_win(buf_id, true, centered_window_opts)

  -- Insert visual selection into scratchpad and restore old contents of "v
  if paste_visual then
    vim.cmd('normal! V"vP') -- enter V-Line mode to overwrite the newline as well
    vim.fn.setreg("v", old_reg_v)
  end

  -- Set local keymap to close window and paste scratchpad contents
  vim.keymap.set("n", close_and_paste_keymap, function()
    vim.api.nvim_win_close(0, false)
    if paste_visual then
      vim.cmd('norm! gv')
    end
    vim.cmd('norm! "oP')
  end, { buffer = buf_id, desc = "Close scratchpad and insert content."})

  vim.api.nvim_create_autocmd("BufUnload", {
    buffer = buf_id,
    callback = function(_)
      -- Yank scratchpad contents into "o without overriding unnamed register
      local unnamed_reg = vim.fn.getreg('"')
      vim.cmd([[ norm! gg0vGg_"oy ]])
      vim.fn.setreg('"', unnamed_reg)
      vim.notify('Scratchpad content yanked to "o')
    end,
  })

end

return latex_scratchpad
