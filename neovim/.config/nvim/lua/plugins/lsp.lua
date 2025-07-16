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

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'mason-org/mason.nvim', opts = {} },
      { 'mason-org/mason-lspconfig.nvim' },

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {
        progress = {
          display = {
            progress_icon = {
              pattern = "dots",
              period = 1,
            }
          }
        }
      } },

      -- Additional lua configuration, makes nvim stuff amazing
      { 'folke/lazydev.nvim' },
    },
    config = function ()
      -- Define LSP-keymaps like goto definition and rename symbol
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('ø', vim.lsp.buf.signature_help, 'Signature Documentation')
          vim.keymap.set('i', '<c-ø>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: Signature Help' })

          -- Lesser used LSP functionality
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })
        end
      })

      -- reduce visual clutter for lsp diagnostics
      vim.diagnostic.config({
        virtual_text = {
          severity = {
            min = vim.diagnostic.severity.ERROR
          }
        },
        signs = {
          severity = {
            min = vim.diagnostic.severity.ERROR
          }
        },
        underline = true,
      })

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "-style=file:~/.clangd-format"
          },
          settings = {
            languages = {
              C = {
                -- other settings
                -- includePath = {
                --   "/usr/local/Cellar/sdl2/2.30.2/include" -- NOT NECESSARY
                -- }
              }
            }
          }
        },
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- tsserver = {},
        pylsp = {
          pylsp = {
            plugins = {
              pycodestyle = {
                enabled = false,
                ignore = {'W391'},
                maxLineLength = 80
              }
            }
          }
        },

        lua_ls = { -- Pleide å være sumneko_lua
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end
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
