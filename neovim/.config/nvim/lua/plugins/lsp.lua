return {

  { "folke/lazydev.nvim", -- LuaLS tailored to Neovim config editing
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section at https://github.com/folke/lazydev.nvim for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Useful status updates for LSP
  { 'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          progress_icon = {
            pattern = "dots",
            period = 1,
          }
        }
      }
    }
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    config = function ()
      vim.lsp.enable({ "luals", "pylsp", "clangd" })
      vim.lsp.config["clangd"] = {
        cmd = {
          "clangd",
          "-style=file:~/.clangd-format"
        },
      }
      vim.lsp.config["luals"] = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
      vim.lsp.config["pylsp"] = {
        pylsp = {
          plugins = {
            pycodestyle = {
              enabled = false,
              ignore = {'W391'},
              maxLineLength = 80
            }
          }
        }
      }

    end
  },

  { -- R stuff
    "R-nvim/R.nvim",
    lazy = false
  },

  -- Flutter shit
  { 'nvim-flutter/flutter-tools.nvim',
    ft = "dart",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
  { 'dart-lang/dart-vim-plugin',
    ft = "dart",
    init = function()
      vim.cmd("let g:dart_style_guide = 2")
    end,
  },

}

-- vim: sts=2 sw=2 et foldmethod=indent
