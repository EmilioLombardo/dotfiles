return {
  -- Git related plugins
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    'lewis6991/gitsigns.nvim',-- {{{
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      gitsigns.setup(opts)
      -- Keymaps {{{

      vim.keymap.set("n", "<leader>h", function() gitsigns.preview_hunk() end,
        { desc = "Gitsigns: Preview hunk under cursor" })

      vim.keymap.set("n", "gs", function() gitsigns.stage_hunk() end,
        { desc = "Gitsigns: Stage/unstage hunk under cursor" })
      vim.keymap.set("n", "gX", function() gitsigns.reset_hunk() end,
        { desc = "Gitsigns: Reset hunk under cursor" })

      vim.keymap.set("x", "gs", function()
        vim.cmd("norm! ") -- ESC out of visual mode to set marks '< and '>
        vim.cmd("'<,'>Gitsigns stage_hunk")
      end, { desc = "Gitsigns: Stage/unstage selected lines" })
      vim.keymap.set("x", "gX", function()
        vim.cmd("norm! ") -- ESC out of visual mode to set marks '< and '>
        vim.cmd("'<,'>Gitsigns reset_hunk")
      end, { desc = "Gitsigns: Reset selected lines" })

      ---@diagnostic disable-next-line
      vim.keymap.set("n", "]c", function() gitsigns.nav_hunk("next") end,
          { desc = "Gitsigns: Go to next unstaged hunk" })

      ---@diagnostic disable-next-line
      vim.keymap.set("n", "[c", function() gitsigns.nav_hunk("prev") end,
          { desc = "Gitsigns: Go to previous unstaged hunk" })

      -- }}}
    end,-- }}}
  },

  {
    "lervag/wiki.vim",-- {{{
    -- tag = "v0.10", -- uncomment to pin to a specific release
    init = function()
      vim.g.wiki_root = '~/wiki'
      vim.g.wiki_mappings_use_defaults = "none"

      vim.g.wiki_mappings_prefix = '<leader>w'

      -- Global mappings (always active)
      -- Prefix followed by...
      -- i -> index, n -> open page by title, j -> journal, x -> reload plugin
      vim.g.wiki_mappings_global = {-- {{{
        ['<plug>(wiki-index)'] = '<wiki-prefix>i',
        ['<plug>(wiki-open)'] = '<wiki-prefix>n',
        ['<plug>(wiki-journal)'] = '<wiki-prefix>j',
        ['<plug>(wiki-reload)'] = '<wiki-prefix>x',
      }-- }}}
      
      -- Local mappings (only active when editing pages of the wiki)
      vim.g.wiki_mappings_local = {-- {{{
        -- g -> graph --
        ['<plug>(wiki-graph-find-backlinks)'] = '<wiki-prefix>gb',
        ['<plug>(wiki-graph-related)'] = '<wiki-prefix>gr',
        ['<plug>(wiki-graph-check-links)'] = '<wiki-prefix>gc',
        ['<plug>(wiki-graph-check-links-g)'] = '<wiki-prefix>gC',
        ['<plug>(wiki-graph-check-orphans)'] = '<wiki-prefix>gO',
        ['<plug>(wiki-graph-in)'] = '<wiki-prefix>gi',
        ['<plug>(wiki-graph-out)'] = '<wiki-prefix>go',
        -- link stuff
        ['<plug>(wiki-link-add)'] = '<wiki-prefix>a',
        ['i_<plug>(wiki-link-add)'] = '<c-q>', -- "Qreate link"
        ['x_<plug>(wiki-link-add)'] = '<wiki-prefix>a',
        ['<plug>(wiki-link-remove)'] = '<wiki-prefix>lr',
        ['<plug>(wiki-link-next)'] = '<wiki-prefix>ln',--'<tab>',
        ['<plug>(wiki-link-prev)'] = '<wiki-prefix>lp',--'<s-tab>',
        ['<plug>(wiki-link-show)'] = '<wiki-prefix>ll',
        ['<plug>(wiki-link-extract-header)'] = '<wiki-prefix>lh',
        ['x_<plug>(wiki-link-extract-header)'] = '<wiki-prefix>lh',
        ['<plug>(wiki-link-follow)'] = 'gl',--'<cr>', -- "go ->"
        ['<plug>(wiki-link-follow-split)'] = '<c-w><cr>',
        ['<plug>(wiki-link-follow-vsplit)'] = '<c-w><tab>',
        ['<plug>(wiki-link-follow-tab)'] = '<c-w>u',
        ['<plug>(wiki-link-return)'] = 'gh',--'<bs>', -- "go <-"
        ['<plug>(wiki-link-transform)'] = '<wiki-prefix>f', -- "forvandle (lenke)"
        ['x_<plug>(wiki-link-transform-visual)'] = '<wiki-prefix>f',--'<cr>',
        ['<plug>(wiki-link-transform-operator)'] = '',--'gl',
        ['<plug>(wiki-link-incoming-toggle)'] = '<wiki-prefix>li',
        ['<plug>(wiki-link-incoming-hover)'] = '<wiki-prefix>lI',
        -- page stuff
        ['<plug>(wiki-page-delete)'] = '<wiki-prefix>d', -- "delete (page)"
        ['<plug>(wiki-page-rename)'] = '<wiki-prefix>rp', -- "rename page"
        ['<plug>(wiki-page-rename-section)'] = '<wiki-prefix>rs', -- "rename section"
        -- toc -- table of contents
        ['<plug>(wiki-toc-generate)'] = '<wiki-prefix>t',
        ['<plug>(wiki-toc-generate-local)'] = '<wiki-prefix>T',
        -- export
        ['<plug>(wiki-export)'] = '<wiki-prefix>p', -- "print"
        ['x_<plug>(wiki-export)'] = '<wiki-prefix>p',
        -- tags
        ['<plug>(wiki-tag-list)'] = '<wiki-prefix>sl',
        ['<plug>(wiki-tag-reload)'] = '<wiki-prefix>sr',
        ['<plug>(wiki-tag-search)'] = '<wiki-prefix>ss',
        ['<plug>(wiki-tag-rename)'] = '<wiki-prefix>sn',
        -- textobjects
        ['o_<plug>(wiki-au)'] = 'au',
        ['x_<plug>(wiki-au)'] = 'au',
        ['o_<plug>(wiki-iu)'] = 'iu',
        ['x_<plug>(wiki-iu)'] = 'iu',
        ['o_<plug>(wiki-at)'] = 'at',
        ['x_<plug>(wiki-at)'] = 'at',
        ['o_<plug>(wiki-it)'] = 'it',
        ['x_<plug>(wiki-it)'] = 'it',
      }-- }}}

      -- Journal-local mappings (only active when editing pages of the journal)
      vim.g.wiki_mappings_local_journal = {-- {{{
        ['<plug>(wiki-journal-prev)'] = '<c-p>',
        ['<plug>(wiki-journal-next)'] = '<c-n>',
        ['<plug>(wiki-journal-copy-tonext)'] = '<leader><c-n>',
        ['<plug>(wiki-journal-toweek)'] = '<wiki-prefix>u',
        ['<plug>(wiki-journal-tomonth)'] = '<wiki-prefix>m',
      }-- }}}

    end-- }}}
  },

  { -- hardtime.nvim: Block repeating stuff like jjjjj and give vim motion hints
    "m4xshen/hardtime.nvim",-- {{{
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disabled_filetypes = {
        ["harpoon"] = true,
        ["grapple"] = true,
      },
    },-- }}}
  },


  { -- grapple: per-project file switcher (replacement for harpoon)
    "cbochs/grapple.nvim",-- {{{
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {-- {{{
      { "<leader><leader>a", "<cmd>Grapple tag<cr>", desc = "Grapple: Tag a file" },
      { "<leader><leader>m", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: Toggle tags menu" },

      { "<leader><leader>j", "<cmd>Grapple select index=1<cr>", desc = "Grapple: Select first tag" },
      { "<leader><leader>k", "<cmd>Grapple select index=2<cr>", desc = "Grapple: Select second tag" },
      { "<leader><leader>l", "<cmd>Grapple select index=3<cr>", desc = "Grapple: Select third tag" },
      { "<leader><leader>ø", "<cmd>Grapple select index=4<cr>", desc = "Grapple: Select fourth tag" },

      { "<leader><leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: Go to next tag" },
      { "<leader><leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: Go to previous tag" },
    },-- }}}
    opts = {-- {{{
      scope = "git",
      icons = false,
      win_opts = {
        width = 60,
        height = 8,
        border = "rounded",
        footer = "",
      },
      -- Use `:silent! edit` instead of `:edit` to open a file with grapple.
      -- This way there is no error if you select the current file while it
      -- has unsaved changes
      command = function(path) vim.cmd("silent! edit " .. path) end,
    },-- }}}
    config = function(_, opts)
      require("grapple").setup(opts)

      local grapple_augroup = vim.api.nvim_create_augroup("Grapple", {})
      -- Autocommand to change grapple scope to cwd for my nvim dotfiles
      vim.api.nvim_create_autocmd({ "DirChanged", "UIEnter", }, {-- {{{
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
      })-- }}}
      -- TODO?: set Grapple use_scope to opts.scope when changing away from nvim dotfiles (DirChangedPre?)
    end-- }}}
  },

  { -- Zen Mode
    "emiliolombardo/zen-mode.nvim",-- {{{
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
    },
    opts = {
      window = {
        width = 90,
        backdrop = 0.7,
      },
    },-- }}}
  },

  { 'nanotee/zoxide.vim' },

  { "ThePrimeagen/vim-be-good", lazy = true, cmd = "VimBeGood" },

}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker nowrap
