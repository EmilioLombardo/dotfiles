return {

  { -- Treesitter: Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    event = "VeryLazy",
    dependencies = {
      -- Additional text objects via treesitter
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function ()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vimdoc', 'vim' },

        highlight = { enable = true },
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            -- scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end
  },

  { -- VimTeX: Improved LaTeX support
    "lervag/vimtex",
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
        ["$"] = "\\[",
        ["$$"] = "\\[",
        ["\\("] = "$",
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

    end,
  },

  { -- Adds keymap "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    opts = {},
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

  -- Auto-pairs parentheses, quotes, etc. in insert mode
  { "jiangmiao/auto-pairs", },

  -- Adds more text objects
  --  Examples:
  --   diq -> delete inside quotes (any type of quote)
  --   cinq -> change inside next quote
  --   c2inq -> change inside next next quote
  { "wellle/targets.vim", event = "VeryLazy" },

  { -- nvim-peekup: handy menu for registers
    "gennaro-tedesco/nvim-peekup",
    lazy = true,
    keys = {
      {'""', '<Plug>PeekupOpen', { desc = "Open peekup window", silent = true }}
    },
    config = function()
      require('nvim-peekup.config').geometry["wrap"] = false
    end,
  },

  { -- Autocompletion (All this is taken from kickstart.nvim)
    'hrsh7th/nvim-cmp',
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
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
          ['<C-p>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
        },
      }
    end,
  },

}


-- vim: ts=2 sts=2 sw=2 et foldmethod=indent foldlevel=1
