return {

  -- Telescope: Fuzzy finder menu (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      local lst = require('telescope').extensions.luasnip

      require('telescope').setup {
        extensions = {
          luasnip = {
            search = function(entry)
              local res = lst.filter_null(string.gsub(entry.context.trigger, [[%(%[%^%%a]%)]], "")) .. " " ..
                -- [[%(%[%^%%a]%)]] matches ([^%a]) exactly
                -- [[%(%[%^%%%a]%)]] matches ([^%x]) with any letter in place of the x
                lst.filter_null(entry.context.name) .. " " ..
                (lst.filter_description(entry.context.name, entry.context.description) or "") .. " " ..
                entry.ft
              -- print(vim.inspect(entry)) -- DEBUG
              -- print(res) -- DEBUG
              return res
            end
          },
        },
        defaults = {
          path_display = { truncate = 3, shorten = { len = 6, exclude = {-1, -2} } },
          mappings = {
            i = {
              -- ['<C-u>'] = false,
              -- ['<C-d>'] = false,
              ["jj"] = {
                require('telescope.actions').close, type = "action",
                --[[ opts = { nowait = true, silent = true } ]] },
              ["<C-j>"] = {
                require('telescope.actions').move_selection_next, type = "action",
                opts = { nowait = true, silent = true }
              },
              ["<C-k>"] = {
                require('telescope.actions').move_selection_previous, type = "action",
                opts = { nowait = true, silent = true }
              },
            },
          },
        },
      }

      require('telescope').load_extension('luasnip')

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, { desc = '[/] Fuzzily search in current buffer]' })

      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      -- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sc', require('telescope.builtin').commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })

      vim.keymap.set('n', '<leader>ss',
        function()
          require'telescope'.extensions.luasnip.luasnip{}
          -- vim.cmd [[ Telescope luasnip ]]
        end, { desc = '[S]earch [S]nippets' })
    end
  },

  -- Fuzzy finder algorithm for Telescope
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  { -- Telescope extension to search through luasnip snippets
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", 'L3MON4D3/LuaSnip' },
  },
}
