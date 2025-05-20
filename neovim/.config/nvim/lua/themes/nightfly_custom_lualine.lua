-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
-- stylua: ignore
local colors = {
  color0   = '#092236',
  color1   = '#ff5874',
  color2   = '#c3ccdc',
  color3   = '#2c3043',
  color6   = '#a1aab8',
  color7   = '#82aaff',
  color8   = '#ae81ff',
  mellow_yellow = "#EAC38C",
  green = "#20c9a7",--"#1FC6A6",
  visual_orange = "#efa26e",--"#f29b60",
}

return {
  replace = {
    a = { fg = colors.color0, bg = colors.color1, gui = 'bold' },
    b = { fg = colors.color1, bg = colors.color3 },
  },
  inactive = {
    a = { fg = colors.color6, bg = colors.color3, gui = '' },
    b = { fg = colors.color6, bg = colors.color3 },
    c = { fg = colors.color6, bg = colors.color3 },
  },
  normal = {
    a = { fg = colors.color0, bg = colors.color7, gui = '' },
    b = { fg = colors.color7, bg = colors.color3 },
    c = { fg = colors.color2, bg = colors.color3 },
  },
  visual = {
    a = { fg = colors.color0, bg = colors.visual_orange, gui = '' },
    b = { fg = colors.visual_orange, bg = colors.color3 },
  },
  insert = {
    a = { fg = colors.color0, bg = colors.green, gui = 'bold' },
    b = { fg = colors.green, bg = colors.color3 },
  },
  command = {
    a = { fg = colors.color0, bg = colors.mellow_yellow, gui = '' },
    b = { fg = colors.mellow_yellow, bg = colors.color3 },
    c = { fg = colors.color2, bg = colors.color3 },
  }
}
