return {

  { -- Render markdown elements with pretty icons and colours
    'MeanderingProgrammer/render-markdown.nvim',-- {{{
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = { { "<leader>m", "<cmd>RenderMarkdown toggle<cr>" } },
    ft = { "markdown", "rmd" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'rmd' },
      completions = { lsp = { enabled = true } },
      heading = {
        width = 'block',
        border = { true, true, false },
        right_pad = 2,
        signs = { ' ', '● ', '* ', '· ', '  ', '  ' },
        icons = { '󰐣 ', '·· ', '··· ', '···· ', '····· ', '······ ' },
      },
      bullet = {
        icons = { '●', '○', '◆', '◇' }, -- default
      },
      checkbox = {
        right_pad = 0, -- make todo items aligned with bullet point items
        -- checked = { icon = "󰄵 ", },
        -- checked = { icon = "󰄲 ", },
        checked = { icon = "󰡖 ", },
        unchecked = { icon = '󰄱 ', },
        custom = {
            todo = { raw = '[-]', rendered = ' ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
      },
      link = {
        custom = {
          ntnu = { pattern = 'ntnu%.no', icon = '󱗝 ' },
          markdown = { pattern = '%.md', icon = '󱗖 ' },
          nixoswiki = { pattern = 'nixos%.wiki', icon = '󱄅 ' },
          nixosforum = { pattern = 'nixos%.org', icon = '󱄅 ' },
          twitter = { pattern = '[^A-Za-z]x%.com', icon = ' ' },
          twitter2 = { pattern = '^x%.com', icon = ' ' },
        },
      },
    },-- }}}
  },

  { -- Fold headings in markdown
    "masukomi/vim-markdown-folding",-- {{{
    ft = { "markdown", "rmd", },
    cmd = { "FoldToggle", },
    init = function()
      -- function MDfoldtext()
      --   local line = vim.fn.getline(vim.v.foldstart)
      --   local heading_level = #line:match("^#+")
      --   local signs = { ' ', ' ●', ' *', ' ·', '  ', '  ' }
      --   local space = string.rep(" ", heading_level - 2)
      --   local sub = line:gsub("^#+", signs[heading_level] .. space)
      --   return sub .. "  "
      -- end
      vim.g.markdown_fold_override_foldtext = 1
      local md_folds_augroup = vim.api.nvim_create_augroup("CustomMarkdownFolds", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "rmd", },
        callback = function()
          -- vim.wo.foldmethod = "expr" -- this is set in ftplugin/markdown.lua
          vim.wo.foldexpr = "NestedMarkdownFolds()"
          -- vim.wo.foldtext = "v:lua.MDfoldtext()"
          vim.wo.foldtext = "" -- retain syntax highlighting of folded headings
          vim.wo.fillchars = "fold: "
        end,
        group = md_folds_augroup,
      })
    end,-- }}}
  },

  { -- Various markdown tools, such as 'toggle emphasis' and 'add list item'
    "tadmccorkle/markdown.nvim",-- {{{
    ft = { "markdown", "rmd" }, -- or 'event = "VeryLazy"'
    opts = {
      -- Disable all keymaps by setting mappings field to 'false'.
      -- Selectively disable keymaps by setting corresponding field to 'false'.
      mappings = {
        inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
        inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
        inline_surround_delete = "gsd",--"ds", -- (string|boolean) delete emphasis surrounding cursor
        inline_surround_change = "gsc",--"cs", -- (string|boolean) change emphasis surrounding cursor
        link_add = "gL",--"gl", -- (string|boolean) add link
        link_follow = "gx", -- (string|boolean) follow link
        go_curr_heading = false,--"]c", -- (string|boolean) set cursor to current section heading
        go_parent_heading = false,--"]p", -- (string|boolean) set cursor to parent section heading
        go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
        go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
      },
      inline_surround = {-- {{{
        -- For the emphasis, strong, strikethrough, and code fields:
        -- * 'key': used to specify an inline style in toggle, delete, and change operations
        -- * 'txt': text inserted when toggling or changing to the corresponding inline style
        emphasis = {
          key = "i",
          txt = "*",
        },
        strong = {
          key = "b",
          txt = "**",
        },
        strikethrough = {
          key = "s",
          txt = "~~",
        },
        code = {
          key = "c",
          txt = "`",
        },
      },-- }}}
      link = {-- {{{
        paste = {
          enable = false, -- whether to convert URLs to links on paste
        },
      },-- }}}
      toc = {-- {{{
        -- Comment text to flag headings/sections for omission in table of contents.
        omit_heading = "toc omit heading",
        omit_section = "toc omit section",
        -- Cycling list markers to use in table of contents.
        -- Use '.' and ')' for ordered lists.
        markers = { "-" },
      },-- }}}
      -- Hook functions allow for overriding or extending default behavior.
      -- Called with a table of options and a fallback function with default behavior.
      -- Signature: fun(opts: table, fallback: fun())
      hooks = {-- {{{
        -- Called when following links. Provided the following options:
        -- * 'dest' (string): the link destination
        -- * 'use_default_app' (boolean|nil): whether to open the destination with default application
        --   (refer to documentation on <Plug> mappings for explanation of when this option is used)
        follow_link = nil,
      },-- }}}
      on_attach = function(bufnr) -- (fun(bufnr: integer)) callback when plugin attaches to a buffer
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map({ 'n', 'i' }, '<c-l>', '<Cmd>MDListItemBelow<CR>', opts)
        map({ 'n', 'i' }, '<m-c-l>', '<Cmd>MDListItemAbove<CR>', opts)
        -- map('n', '<M-c>', '<Cmd>MDTaskToggle<CR>', opts)
        -- map('x', '<M-c>', ':MDTaskToggle<CR>', opts)
      end,
    },-- }}}
  },

  { -- Make table editing easy :)
    "dhruvasagar/vim-table-mode",-- {{{
    ft = { "markdown", "rmd" },
    cmd = {
      "TableModeEnable", "TableModeToggle", "TableModeDisable",
      "TableModeRealign", "Tableize", "TableSort",
    },
    keys = { "<leader>tm", "<leader>tt", "<leader>T" },
    init = function()
      -- Default config
      vim.g.table_mode_delete_row_map = "<Leader>tdd"
      vim.g.table_mode_delete_column_map = "<Leader>tdc"
      vim.g.table_mode_insert_column_after_map = "<Leader>tic"
      vim.g.table_mode_insert_column_before_map = "<Leader>tiC"
    end-- }}}
  },

  {
    "emiliolombardo/lists.vim",
    ft = { "markdown", "rmd", },
    init = function()
      -- vim.keymap.set("i", "<c-s>", "<Plug>(lists-toggle)")
      vim.g.lists_maps_default_override = {
        ["<plug>(lists-toggle)"] = "<c-s>",
        ["i_<plug>(lists-toggle)"] = "<c-s>",
        ["<plug>(lists-toggle-checkbox)"] = "",
        ["i_<plug>(lists-new-element)"] = "",
        ["<plug>(lists-moveup)"] = "<leader>lk",
        ["<plug>(lists-movedown)"] = "<leader>lj",
        ["<plug>(lists-uniq)"] = "<leader>lu",
        ["<plug>(lists-uniq-local)"] = "<leader>lU",
        ["<plug>(lists-bullet-toggle-local)"] = "<leader>lT",
        ["<plug>(lists-bullet-toggle-all)"] = "<leader>lt",
        -- ["<plug>(lists-al)"] = "al",
        -- ["<plug>(lists-il)"] = "il",
          -- \ 'i_<plug>(lists-new-element)': '<c-t>',
          -- \ 'i_<plug>(lists-toggle)': '',
          -- \ '<plug>(lists-toggle)': '<c-y>',
      }
    end
  },

}

-- vim: foldmethod=marker
