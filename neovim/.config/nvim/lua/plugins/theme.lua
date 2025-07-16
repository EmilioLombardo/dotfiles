return {
  { -- MAIN COLORSCHEME
    "bluz71/vim-nightfly-colors",
    lazy = false,
    priority = 1000,
    config = function ()
      local custom_highlight_augroup = vim.api.nvim_create_augroup("CustomHighlight", {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nightfly",
        callback = function()
          local palette = require("nightfly").palette
          local hl_Normal = vim.api.nvim_get_hl(0, {name="Normal"})
          local hl_LineNr = vim.api.nvim_get_hl(0, {name="LineNr"})
          vim.api.nvim_set_hl(0, "Comment", { fg = palette.steel_blue, italic = false })
          vim.api.nvim_set_hl(0, "@field", { fg = "#59d6ae" })
          vim.api.nvim_set_hl(0, "@namespace", { fg = "#59d6ae" })
          vim.api.nvim_set_hl(0, "@constant.builtin", { fg = palette.orange })
          vim.api.nvim_set_hl(0, "@parameter", { fg = "#ffc7b5" })
          vim.api.nvim_set_hl(0, "@type", { fg = "#29d89e" })
          -- vim.api.nvim_set_hl(0, "@type.qualifier", { fg = "#d35281" })
          vim.api.nvim_set_hl(0, "@type.qualifier", { fg = "#ff8d59" })

          vim.api.nvim_set_hl(0, "CursorLineSign", { bg = hl_Normal.bg })

          -- Floating windows
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = hl_Normal.bg })
          vim.api.nvim_set_hl(0, "FloatTitle", { fg = hl_LineNr.fg })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = hl_LineNr.fg })
        end,
        group = custom_highlight_augroup,
      })

      vim.cmd [[colorscheme nightfly]]
    end
  },

  {'norcalli/nvim-colorizer.lua', event = "VeryLazy", opts = { "*" }},

  { -- Lualine: Fancier statusline
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    -- lazy = false,
    opts = {
      options = {
        icons_enabled = true,
        theme = require("themes.nightfly_custom_lualine"),
        component_separators = '│',-- '|',
        -- section_separators = '',
        -- section_separators = { left = '',right = '' },
        section_separators = { left = ' ',right = ' ' },
      },
      sections = {
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            --[[ symbols = {
              -- error = ' ',
              error = ' ',
              -- warn = ' ',
              warn = ' ',
              -- info = ' ',
              info = ' ',
              -- hint = ''
              -- hint = ''
              hint = ''
            }, ]]
          }
        },
      },
    }
  },
  { -- Filetype glyphs
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    -- config = function()
    --   require('nvim-web-devicons').set_icon {
    --     txt = {
    --       icon = "",
    --       -- color = "#428850",
    --       -- cterm_color = "65",
    --       name = "Txt"
    --     }
    --   }
    -- end,
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    main = 'ibl',
    opts = {
      indent = {
        char = '▏', --[['┊']] --[[ , highlight = { "Comment" } ]]
      },
      scope = { enabled = false },
    },
  },

  { -- Colour line number according to current mode
    "mawkler/modicator.nvim",
    event = "VeryLazy",
    opts = {
      -- Warn if any required option is missing. May emit false positives if some
      -- other plugin modifies them, which in that case you can just ignore
      show_warnings = false,
      highlights = {
        -- Default options for bold/italic
        defaults = {
          bold = false,
          italic = false,
        },
      },
      integration = {
        lualine = {
          enabled = true,
          -- Letter of lualine section to use (if `nil`, gets detected automatically)
          mode_section = nil,
          -- Whether to use lualine's mode highlight's foreground or background
          highlight = 'bg',
        },
      },
    },
  },

  -- More themes
  "catppuccin/nvim",
  "phanviet/vim-monokai-pro",
  "rose-pine/neovim",
  "bluz71/vim-moonfly-colors",
  "navarasu/onedark.nvim", -- Theme inspired by Atom

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=indent
