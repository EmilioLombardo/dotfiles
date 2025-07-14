return {
  -- Git related plugins
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  { 'lewis6991/gitsigns.nvim', opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  } },

  { -- hardtime.nvim: Block repeating stuff like jjjjj and give vim motion hints
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disabled_filetypes = {
        ["harpoon"] = true,
      },
    },
  },

  { -- Telescope extension to search through luasnip snippets
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", 'L3MON4D3/LuaSnip' },
  },

  -- Telescope: Fuzzy finder menu (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      local lst = require('telescope').extensions.luasnip
      local luasnip = require('luasnip')

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

      vim.keymap.set('n', '<leader>ss',
        function()
          require'telescope'.extensions.luasnip.luasnip{}
          -- vim.cmd [[ Telescope luasnip ]]
        end, { desc = '[S]earch [S]nippets' })
    end
  },
  -- Fuzzy finder algorithm for Telescope
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  { -- harpoon: per-project file switcher
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- lazy = false,
    event = "VeryLazy",
    config = function ()
      local harpoon = require("harpoon")
      local extensions = require("harpoon.extensions")
      harpoon:setup({
        settings = { save_on_toggle = true }
      })
      -- keymap to add current file to harpoon list
      vim.keymap.set("n", "<leader><leader>a", function() harpoon:list():add() end,
        { desc = "Harpoon [A]dd" })
      -- keymap to toggle quick menu showing harpoon list
      vim.keymap.set("n", "<leader><leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon quick [M]enu" })
      -- keymap to select file no. 1
      vim.keymap.set("n", "<leader><leader>j", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon file [1]" })
      -- keymap to select file no. 2
      vim.keymap.set("n", "<leader><leader>k", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon file [2]" })
      -- keymap to select file no. 3
      vim.keymap.set("n", "<leader><leader>l", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon file [3]" })
      -- keymap to select file no. 4
      vim.keymap.set("n", "<leader><leader>ø", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file [4]" })

      -- Highlight current file in the Harpoon quick menu
      harpoon:extend(extensions.builtins.highlight_current_file())

      -- Make sure modeline is processed when navigating to a new file
      harpoon:extend(extensions.builtins.command_on_nav("doautocmd BufEnter"));

    end,
  },

  { -- Zen Mode
    "folke/zen-mode.nvim",
    -- lazy = true,
    cmd = "ZenMode",
  },

  { 'nanotee/zoxide.vim' },

  { "ThePrimeagen/vim-be-good", lazy = true, cmd = "VimBeGood" },

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=indent foldlevel=1 nowrap
