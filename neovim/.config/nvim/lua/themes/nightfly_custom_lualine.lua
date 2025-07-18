-- Modified version of the lualine nightfly colorscheme
-- stylua: ignore
local colors = {
  dark_blue   = '#092236', -- nightfly dark_blue
  white       = '#c3ccdc', -- nightfly white
  slate_blue  = '#2c3043', -- nightfly slate_blue
  cadet_blue  = '#a1aab8', -- nightfly cadet_blue
  normal_col  = '#82aaff', -- nightfly blue
  replace_col = '#ff5874', -- nightfly watermelon
  insert_col  = "#21c7a8", -- nightfly emerald
  command_col = "#ffcb8b", -- nightfly peach -- EDITED FROM "#EAC38C",
  visual_col  = "#efa26e", -- custom orange :)
  -- visual_col  = "#f78c6c", -- nightfly orange
  -- visual_col  = '#ae81ff', -- nightfly purple
}

return {
  replace = {
    a = { fg = colors.dark_blue, bg = colors.replace_col, gui = 'bold' },
    b = { fg = colors.replace_col, bg = colors.slate_blue },
  },
  inactive = {
    a = { fg = colors.cadet_blue, bg = colors.slate_blue, gui = '' },
    b = { fg = colors.cadet_blue, bg = colors.slate_blue },
    c = { fg = colors.cadet_blue, bg = colors.slate_blue },
  },
  normal = {
    a = { fg = colors.dark_blue, bg = colors.normal_col, gui = '' },
    b = { fg = colors.normal_col, bg = colors.slate_blue },
    c = { fg = colors.white, bg = colors.slate_blue },
  },
  visual = {
    a = { fg = colors.dark_blue, bg = colors.visual_col, gui = '' },
    b = { fg = colors.visual_col, bg = colors.slate_blue },
  },
  insert = {
    a = { fg = colors.dark_blue, bg = colors.insert_col, gui = 'bold' },
    b = { fg = colors.insert_col, bg = colors.slate_blue },
  },
  command = {
    a = { fg = colors.dark_blue, bg = colors.command_col, gui = '' },
    b = { fg = colors.command_col, bg = colors.slate_blue },
    c = { fg = colors.white, bg = colors.slate_blue },
  }
}
