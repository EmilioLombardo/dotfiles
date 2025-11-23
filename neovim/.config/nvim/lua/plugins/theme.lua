-- used for a lualine component
-- symbol codes: e712, e70f, e711
local fileformat_symbols = { unix = '', dos = '', mac = '', }

return {
  { -- MAIN COLORSCHEME
    "bluz71/vim-nightfly-colors",-- {{{
    lazy = false,
    priority = 1000,
    config = function ()
      local custom_highlight_augroup = vim.api.nvim_create_augroup("CustomHighlight", {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nightfly",
        callback = function()
          local function set_hl(name, opts)
            vim.api.nvim_set_hl(0, name, opts)
          end
          local palette = require("nightfly").palette
          local hl_Normal = vim.api.nvim_get_hl(0, {name="Normal"})
          local hl_LineNr = vim.api.nvim_get_hl(0, {name="LineNr"})

          -- Code {{{
          set_hl("Comment", { fg = palette.steel_blue, italic = false })
          set_hl("@field", { fg = "#59d6ae" })
          set_hl("@namespace", { fg = "#59d6ae" })
          set_hl("@constant.builtin", { fg = palette.orange })
          set_hl("@parameter", { fg = "#ffc7b5" })
          set_hl("@type", { fg = "#29d89e" })
          -- set_hl("@type.qualifier", { fg = "#d35281" })
          set_hl("@type.qualifier", { fg = "#ff8d59" })
          -- }}}

          -- Signcolumn {{{
          set_hl("CursorLineSign", { bg = hl_Normal.bg })
          set_hl("SignColumn", { fg = hl_LineNr.fg }) -- for grapple list
          -- }}}

          -- Floating windows {{{
          set_hl("NormalFloat", { bg = hl_Normal.bg })
          set_hl("FloatTitle", { fg = hl_LineNr.fg })
          set_hl("FloatBorder", { fg = hl_LineNr.fg })
          -- }}}

          -- Markdown {{{
          set_hl("@markup.strong.markdown_inline", { bold = true, fg = palette.orchid, })
          set_hl("@markup.quote.markdown", { fg = palette.cinnamon, })
          set_hl("@markup.list.markdown", { bold = true, fg = palette.watermelon, })
          set_hl("RenderMarkdownBullet", { bold = true, fg = palette.watermelon, })
          -- Heading 1
          set_hl("@markup.heading.1.markdown", { bold = true, fg = palette.lavender })
          set_hl("RenderMarkdownH1Bg", { fg = palette.lavender, bg = palette.regal_blue })
          -- Heading 2
          set_hl("@markup.heading.2.markdown", { fg = palette.violet }) -- default: lavender
          set_hl("RenderMarkdownH2Bg", { fg = palette.violet, bg = palette.stone_blue })
          -- Heading 3
          set_hl("@markup.heading.3.markdown", { fg = palette.watermelon }) -- default: turquoise
          set_hl("RenderMarkdownH3Bg", { fg = palette.watermelon, bg = palette.storm_blue })
          -- Heading 4
          set_hl("@markup.heading.4.markdown", { fg = palette.cinnamon }) -- defualt: orange
          set_hl("RenderMarkdownH4Bg", { fg = palette.cinnamon, bg = palette.storm_blue })
          -- Heading 5
          set_hl("@markup.heading.5.markdown", { fg = palette.orchid }) -- default: malibu
          set_hl("RenderMarkdownH5Bg", { fg = palette.orchid, bg = palette.storm_blue })
          -- Heading 6
          set_hl("@markup.heading.6.markdown", { fg = palette.ash_blue }) -- defualt: violet
          set_hl("RenderMarkdownH6Bg", { fg = palette.ash_blue, bg = palette.storm_blue })
          -- }}}

        end,
        group = custom_highlight_augroup,
      })

      vim.cmd [[colorscheme nightfly]]
    end-- }}}
  },

  { -- colorizer: highlight colour codes like #00FFAA
    'norcalli/nvim-colorizer.lua',-- {{{
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

      -- User commands to switch between fg and bg display modes {{{
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
      -- }}}
    end,-- }}}
  },

  { -- Lualine: Fancier statusline
    'nvim-lualine/lualine.nvim',-- {{{
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
        section_separators = { left = '',right = '' },
        -- section_separators = { left = ' ',right = '' },
      },
      sections = {-- {{{
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
      },-- }}}
    }-- }}}
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',-- {{{
    lazy = false,
    main = 'ibl',
    opts = {
      indent = {
        -- char = '▏', --[['┊']] --[[ , highlight = { "Comment" } ]]
        -- char = '│',
        char = '┃',
      },
      scope = { enabled = false },
    },-- }}}
  },

  { -- Colour line number according to current mode
    "mawkler/modicator.nvim",-- {{{
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
    },-- }}}
  },

  { -- Render markdown elements with pretty icons and colours
    'MeanderingProgrammer/render-markdown.nvim',-- {{{
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'rmd' },
      completions = { lsp = { enabled = true } },
      heading = {
        width = 'block',
        border = { true, true, false },
        right_pad = 2,
        signs = { '󰐣 ', '● ', '* ', '· ', '  ', '  ' },
        icons = { '󰐣 ', '·· ', '··· ', '···· ', '····· ', '······ ' },
      },
      bullet = {
        icons = { '●', '○', '◆', '◇' }, -- default
      },
      checkbox = {
        right_pad = 0, -- make todo items aligned with bullet point items
        checked = { icon = "󰄵 ", },
        unchecked = { icon = '󰄱 ', },
      },
    },-- }}}
  },

  -- -- More themes
  -- "catppuccin/nvim",
  -- "phanviet/vim-monokai-pro",
  -- "rose-pine/neovim",
  -- "bluz71/vim-moonfly-colors",
  -- "navarasu/onedark.nvim", -- Theme inspired by Atom

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
