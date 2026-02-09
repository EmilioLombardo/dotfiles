local function remove_by_value(tbl, value)-- {{{
  for i = #tbl, 1, -1 do
    if tbl[i] == value then
      table.remove(tbl, i)
    end
  end
end-- }}}

return {

  { -- Treesitter: Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function ()
      local ts = require("nvim-treesitter")

      -- Install some parsers 
      local default_parsers = {
        'c', 'cpp', 'lua', 'python', 'vimdoc', 'vim', "markdown",
        "markdown_inline", "yaml", "csv", "html",
      }
      for _, parser in ipairs(default_parsers) do
        ts.install(parser)
      end

      -- Auto-start all installed parsers by default.
      local parsers_to_enable = ts.get_installed()

      -- Disable automatic call to vim.treesitter.start() for some parsers {{{
      local parsers_disable_hl = {
        -- The latex parser is needed for the R.nvim plugin, but I don't want
        -- to use it for highlighting .tex files, since I prefer VimTeX to do
        -- that. Therefore "latex" is listed here.
        "latex",
      }
      for _, parser in ipairs(parsers_disable_hl) do
        remove_by_value(parsers_to_enable, parser)
      end-- }}}

      -- Find the relevant FileType patterns for each parser {{{
      local patterns = {}
      for _, parser in ipairs(parsers_to_enable) do
        local parser_patterns = vim.treesitter.language.get_filetypes(parser)
        for _, pp in pairs(parser_patterns) do
          table.insert(patterns, pp)
        end
      end-- }}}

      -- Autocmd to start treesitter for the relevant filetypes {{{
      local treesitter_augroup = vim.api.nvim_create_augroup(
        "treesitter_augroup", { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = patterns,
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
        group = treesitter_augroup,
      })-- }}}

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
