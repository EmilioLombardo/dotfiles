return {

  { -- VimTeX: Improved LaTeX support
    "lervag/vimtex",-- {{{
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_imaps_enabled = 0
      vim.g.vimtex_view_skim_sync = 1 -- do forward search after compile
      vim.g.vimtex_view_skim_no_select = 1 -- don't highlight text after forward search

      vim.g.vimtex_delim_toggle_mod_list = {
        { [[\left]], [[\right]] },
        { [[\bigl]], [[\bigr]] },
        { [[\Bigl]], [[\Bigr]] },
        { [[\biggl]], [[\biggr]] },
        { [[\Biggl]], [[\Biggr]] },
      }

      vim.g.vimtex_env_toggle_math_map = {
        ["$"] = "$$",
        ["$$"] = "\\[",
        ["\\["] = "equation",
        ["equation"] = "align",
      }

      -- use m instead of $ for toggle, change and delete math environment
      vim.keymap.set({"n"}, "tsm", "<Plug>(vimtex-env-toggle-math)")
      vim.keymap.set({"n"}, "csm", "<Plug>(vimtex-env-change-math)")
      vim.keymap.set({"n"}, "dsm", "<Plug>(vimtex-env-delete-math)")
      -- Use 'ai' and 'ii' for the item text object
      vim.keymap.set({"x", "o"}, "ai", "<Plug>(vimtex-am)")
      vim.keymap.set({"x", "o"}, "ii", "<Plug>(vimtex-im)")
      -- Use 'am' and 'im' for the inline math text object
      vim.keymap.set({"x", "o"}, "am", "<Plug>(vimtex-a$)")
      vim.keymap.set({"x", "o"}, "im", "<Plug>(vimtex-i$)")

    end,-- }}}
  },

  {
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
      inline_surround = {
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
      },
      link = {
        paste = {
          enable = false, -- whether to convert URLs to links on paste
        },
      },
      toc = {
        -- Comment text to flag headings/sections for omission in table of contents.
        omit_heading = "toc omit heading",
        omit_section = "toc omit section",
        -- Cycling list markers to use in table of contents.
        -- Use '.' and ')' for ordered lists.
        markers = { "-" },
      },
      -- Hook functions allow for overriding or extending default behavior.
      -- Called with a table of options and a fallback function with default behavior.
      -- Signature: fun(opts: table, fallback: fun())
      hooks = {
        -- Called when following links. Provided the following options:
        -- * 'dest' (string): the link destination
        -- * 'use_default_app' (boolean|nil): whether to open the destination with default application
        --   (refer to documentation on <Plug> mappings for explanation of when this option is used)
        follow_link = nil,
      },
      on_attach = nil, -- (fun(bufnr: integer)) callback when plugin attaches to a buffer
    },-- }}}
  },

  { -- Extends functionality for commenting visual regions/lines (keybind `gc`)
    'numToStr/Comment.nvim', event = "VeryLazy", opts = {},
  },

  -- Detects tabstop and shiftwidth automatically for each file
  { 'tpope/vim-sleuth', event = "VeryLazy" },

  -- Provides shortcuts for editing surrounding symbols.
  --  Examples:
  --    cs'" -> changes surrounding ' to " (normal mode)
  --    ysiw" -> surrounds inner word with double quotes (normal mode)
  --    S) -> surrounds visual selection with parentheses (visual mode)
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Allows . to repeat plugin commands as well as vim-native commands
  { "tpope/vim-repeat", event = "VeryLazy" },

  { -- Auto-pairs parentheses, quotes, etc. in insert mode
    "jiangmiao/auto-pairs",-- {{{
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "markdown" },
        callback = function()
          vim.b.AutoPairs = vim.fn.AutoPairsDefine({["$"]="$"})
        end
      })
    end,-- }}}
  },

  -- Adds more text objects
  --  Examples:
  --   diq -> delete inside quotes (any type of quote)
  --   cinq -> change inside next quote
  --   c2inq -> change inside next next quote
  { "wellle/targets.vim", event = "VeryLazy" },

  { 'mbbill/undotree', event = "VeryLazy" },

  { -- nvim-peekup: handy menu for registers
    "gennaro-tedesco/nvim-peekup",-- {{{
    lazy = true,
    keys = {
      {'""', '<Plug>PeekupOpen', { desc = "Open peekup window", silent = true }}
    },
    config = function()
      require('nvim-peekup.config').geometry["wrap"] = false
    end,-- }}}
  },

  { -- Snippets
    'L3MON4D3/LuaSnip',-- {{{
    event = "InsertEnter",
    config = function ()
      local luasnip = require('luasnip')

      luasnip.config.set_config{
        -- Enable autotriggered snippets
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      }

      -- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
      require("luasnip.loaders.from_lua").lazy_load({paths = { "~/.config/nvim/LuaSnip/" }})

      -- other snippet-related keymaps are defined in the nvim-cmp config
    end-- }}}
  },

  { -- Code completion
    'hrsh7th/nvim-cmp',-- {{{
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    config = function ()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {-- {{{
          -- Select [n]ext / [p]revious item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-1),
          ['<C-f>'] = cmp.mapping.scroll_docs(1),
          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
          -- Move to right of snippet expansion
          ['jk'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          -- Move to left of snippet expansion
          ['jh'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },-- }}}
        sources = {-- {{{
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
        },-- }}}
        window = { documentation = { border = vim.o.winborder or "rounded", scrollbar = true, } },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      vim.lsp.config('*', {
        capabilities = capabilities,
        root_markers = { '.git' },
      })

    end,
    -- }}}
  },
}


-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
