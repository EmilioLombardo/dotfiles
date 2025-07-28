-- used for a lualine component
-- symbol codes: e712, e70f, e711
local fileformat_symbols = { unix = '', dos = '', mac = '', }

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

          vim.api.nvim_set_hl(0, "SignColumn", { fg = hl_LineNr.fg }) -- for grapple list

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

  { -- colorizer: highlight colour codes like #00FFAA
    'norcalli/nvim-colorizer.lua',
    cmd = {
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
      "ColorizerModeFg",
      "ColorizerModeBg",
    },
    ft = { "css", "html" },
    config = function()
      local colorizer = require("colorizer")
      local filetypes = {
        html = { names = false },
        css = { css = true }
      }
      local user_default_options = { mode = "background" }
      local user_default_options_bg = { mode = "background" }
      local user_default_options_fg = { mode = "foreground" }

      colorizer.setup(filetypes, user_default_options)

      vim.api.nvim_create_user_command("ColorizerModeFg",
        function()
          vim.cmd [[ ColorizerDetachFromBuffer ]]
          colorizer.setup(filetypes, user_default_options_fg)
          vim.cmd [[ ColorizerAttachToBuffer ]]
        end,
        { desc = "Set display mode to foreground and attach to buffer" })

      vim.api.nvim_create_user_command("ColorizerModeBg",
        function()
          vim.cmd [[ ColorizerDetachFromBuffer ]]
          colorizer.setup(filetypes, user_default_options_bg)
          vim.cmd [[ ColorizerAttachToBuffer ]]
        end,
        { desc = "Set display mode to background and attach to buffer" })
    end,

  },

  { -- Lualine: Fancier statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    -- lazy = false,
    opts = {
      options = {
        icons_enabled = true,
        theme = require("themes.nightfly_custom_lualine"),
        component_separators = '│',-- '|',
        -- section_separators = '',
        -- section_separators = { left = '',right = '' },
        -- section_separators = { left = ' ',right = ' ' },
        section_separators = { left = ' ',right = '' },
      },
      sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics', },
        lualine_x = {
          -- Custom lualine component:
          -- Shows fileencoding, but only if it's NOT utf-8
          function()
            local encoding = vim.bo.fileencoding
            if encoding == "utf-8" then return "" end
            return encoding
          end,
          -- Custom lualine component:
          -- Shows fileformat, but only if it's NOT unix
          function()
            local fileformat = vim.bo.fileformat
            if fileformat == "unix" then return "" end
            if require'lualine'.get_config().options.icons_enabled then
              return fileformat_symbols[fileformat] or fileformat
            else
              return fileformat
            end
          end,
          'filetype',
        },
      },
    }
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
