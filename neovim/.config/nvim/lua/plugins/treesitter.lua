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
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vimdoc', 'vim',
          "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv",
          "html",
        },
        highlight = {-- {{{
          enable = true,
          disable = function(lang, bufnr)
            -- disable for .tex files to avoid conflict with VimTeX plugin
            local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
            return lang == "latex" and ft == "tex"
          end
        },-- }}}
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {-- {{{
          enable = true,
          keymaps = {
            init_selection = '<c-g>',
            node_incremental = '<c-g>',
            -- scope_incremental = '<c-s>',
            node_decremental = '<c-h>',
          },
        },-- }}}
        textobjects = {
          select = {-- {{{
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
          },-- }}}
          move = { -- {{{
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
          },-- }}}
          swap = {-- {{{
            enable = true,
            swap_next = { ['<leader>a'] = '@parameter.inner', },
            swap_previous = { ['<leader>A'] = '@parameter.inner', },
          },-- }}}
        },
      }
    end
  },

}

-- vim: foldmethod=marker
