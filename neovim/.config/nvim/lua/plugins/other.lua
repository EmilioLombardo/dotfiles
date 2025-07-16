return {
  -- Git related plugins
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })

      vim.keymap.set("n", "<leader>h", function() gitsigns.preview_hunk() end,
        { desc = "Gitsigns: Preview hunk under cursor" })

      ---@diagnostic disable-next-line
      vim.keymap.set("n", "]c", function() gitsigns.nav_hunk("next") end,
          { desc = "Gitsigns: Go to next unstaged hunk" })

      ---@diagnostic disable-next-line
      vim.keymap.set("n", "[c", function() gitsigns.nav_hunk("prev") end,
          { desc = "Gitsigns: Go to previous unstaged hunk" })
    end,
  },

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

  { -- harpoon: per-project file switcher
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
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
      vim.keymap.set("n", "<leader><leader>m", function()
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title = " Harpoon ",
          border = "rounded" or vim.o.winborder,
        })
      end, { desc = "Harpoon quick [M]enu" })
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
    "emiliolombardo/zen-mode.nvim",
    cmd = "ZenMode",
  },

  { 'nanotee/zoxide.vim' },

  { "ThePrimeagen/vim-be-good", lazy = true, cmd = "VimBeGood" },

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=indent nowrap
