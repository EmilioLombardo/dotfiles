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
        ["grapple"] = true,
      },
    },
  },


  { -- grapple: per-project file switcher (replacement for harpoon)
    "cbochs/grapple.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<leader><leader>a", "<cmd>Grapple tag<cr>", desc = "Grapple: Tag a file" },
      { "<leader><leader>m", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: Toggle tags menu" },

      { "<leader><leader>j", "<cmd>Grapple select index=1<cr>", desc = "Grapple: Select first tag" },
      { "<leader><leader>k", "<cmd>Grapple select index=2<cr>", desc = "Grapple: Select second tag" },
      { "<leader><leader>l", "<cmd>Grapple select index=3<cr>", desc = "Grapple: Select third tag" },
      { "<leader><leader>ø", "<cmd>Grapple select index=4<cr>", desc = "Grapple: Select fourth tag" },

      { "<leader><leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: Go to next tag" },
      { "<leader><leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: Go to previous tag" },
    },
    opts = {
      scope = "git",
      icons = false,
      win_opts = {
        width = 60,
        height = 8,
        border = "rounded",
        footer = "",
      }
    },
    config = function(_, opts)
      require("grapple").setup(opts)

      local grapple_augroup = vim.api.nvim_create_augroup("Grapple", {})
      -- Autocommand to change grapple scope to cwd for my nvim dotfiles
      vim.api.nvim_create_autocmd({ "DirChanged", "UIEnter", }, {
        -- pattern = '*/.dotfiles/neovim/.config/nvim/*',
        -- pattern = vim.fn.expand('~') .. '*/.dotfiles/neovim/.config/nvim/*',
        pattern = "*",
        callback = function()
          -- Check if cwd ends with ".dotfiles/neovim/.config/nvim"
          if string.find(vim.fn.getcwd(), ".+/%.dotfiles/neovim/%.config/nvim$") then
            vim.cmd("Grapple use_scope cwd")
          end
        end,
        group = grapple_augroup,
      })
      -- TODO?: set Grapple use_scope to opts.scope when changing away from nvim dotfiles (DirChangedPre?)
    end
  },

  { -- Zen Mode
    "emiliolombardo/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
    },
    opts = {
      window = {
        width = 90,
        backdrop = 0.7,
      },
    },
  },

  { 'nanotee/zoxide.vim' },

  { "ThePrimeagen/vim-be-good", lazy = true, cmd = "VimBeGood" },

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=indent nowrap
