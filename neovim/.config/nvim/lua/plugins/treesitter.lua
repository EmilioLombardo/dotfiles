return {

  { -- Treesitter: Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function ()
      local ts = require("nvim-treesitter")
      local parsers = {
        'c', 'cpp', 'lua', 'python', 'vimdoc', 'vim', "markdown",
        "markdown_inline", "r", "rnoweb", "yaml", "csv", "html",
      }
      for _, parser in ipairs(parsers) do
        ts.install(parser)
      end

      -- Not every tree-sitter parser is the same as the file type detected, so
      -- we need to get the relevant filetype patterns for each parser.
      local patterns = {}
      for _, parser in ipairs(parsers) do
        local parser_patterns = vim.treesitter.language.get_filetypes(parser)
        for _, pp in pairs(parser_patterns) do
          table.insert(patterns, pp)
        end
      end

      local treesitter_augroup = vim.api.nvim_create_augroup(
        "treesitter_augroup", { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = patterns,
        callback = function()
          vim.treesitter.start()
        end,
        group = treesitter_augroup,
      })

    end
  },

  { -- Treesitter-textobjects: additional textobjects {{{
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    main = "nvim-treesitter-textobjects",
    opts = {
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
  },-- }}}

}

-- vim: foldmethod=marker
