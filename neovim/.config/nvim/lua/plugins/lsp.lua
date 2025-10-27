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
      vim.lsp.enable({ "lua_ls", "pylsp", "clangd", "nixd", })

      -- TODO? move lsp configs to nvim/lsp/

      vim.lsp.config["clangd"] = {
        cmd = {
          "clangd",
          "-style=file:~/.clangd-format"
        },
      }

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        }
      })
      -- vim.lsp.config["luals"] = {
      --   Lua = {
      --     workspace = { checkThirdParty = false },
      --     telemetry = { enable = false },
      --   },
      -- }

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
