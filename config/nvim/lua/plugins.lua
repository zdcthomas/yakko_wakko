local execute = vim.api.nvim_command
local fn = vim.fn
local config = require('config.general')
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'
    vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")
    use {'lewis6991/impatient.nvim', rocks = 'mpack'}
    require('impatient')
    use 'michaeljsmith/vim-indent-object'
    use 'tpope/vim-commentary'
    use {
      'mattn/emmet-vim',
      ft = 'html'
    }

    use {
      'machakann/vim-sandwich',
      config = function ()
        vim.cmd([[
          exec 'source ' . "~/.vim/settings/plugins/sandwich_settings.vim"
        ]])
      end
    }

    use {
      'justinmk/vim-dirvish',
      requires = {
        'kristijanhusak/vim-dirvish-git',
        'roginfarrer/vim-dirvish-dovish',
      },
      config = config.dirvish
    }

    use {
      'nicwest/vim-camelsnek',
      config = config.camelsnek
    }

    use {
      'windwp/nvim-autopairs',
      on = "InsertEnter",
      config = config.autopairs
    }

    use {
      'lukas-reineke/format.nvim',
      cmd = {"Format", "FormatWrite"},
      config = function()
        require "format".setup {
          ["*"] = {
            {cmd = {"sed -i 's/[ \t]*$//'"}} -- remove trailing whitespace
          },
          lua = {
            {
              cmd = {
                function(file)
                  return string.format("luafmt -l %s -w replace %s", vim.bo.textwidth, file)
                end
              }
            }
          },
          javascript = {
            {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
          },
          markdown = {
            {cmd = {"prettier -w"}},
          }
        }
      end
    }

    use {
      'tweekmonster/startuptime.vim',
      cmd = "StartupTime"
    }

    use {
      'hoob3rt/lualine.nvim',
      requires = {
        {'nvim-lua/lsp-status.nvim' }
      },
      config = config.lualine
    }

    use {
      'junegunn/vim-easy-align',
      keys = {
        {'x', 'ga'},
        {'n', 'ga'},
      },
      cmd = 'EasyAlign',
      config = config.easy_align
    }

    use {'mhinz/vim-startify',
      config = function()
        require('config.startify').setup()
      end
    }

    use {
      'nvim-telescope/telescope.nvim',
      keys = {
        '<Leader>p',
        '<Leader>F',
        '<Leader>*',
        '<Leader>ww',
      },
      cmd = {'Telescope'},
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      },
      config = function()
      require('config.telescope').setup()
    end
    }

    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'p00f/nvim-ts-rainbow',
        {
          'nvim-treesitter/playground',
          cmd = 'TSPlaygroundToggle'
        },
      },
      config = function()
        require('config.treesitter').setup()
      end
    }

    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = config.git_signs
    }

    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-calc',
        {'andersevenrud/compe-tmux', branch = 'cmp'},
      },
      config = function ()
        -- See lspconfig comment on why this is in a function wrapper
        require('config.cmp').setup()
      end
    }

    use {'gruvbox-community/gruvbox',
      config = function()
        vim.cmd("colorscheme gruvbox")
      end
    }

    use {
      'hrsh7th/vim-vsnip',
      requires = {'hrsh7th/vim-vsnip-integ'},
      config = function ()
        vim.g.vsnip_snippet_dir = "~/yakko_wakko/config/nvim/snippets"
        vim.g.vsnip_filetypes = {
          html_css = {'html', 'css'}
        }
      end
    }

    use {
      'kabouzeid/nvim-lspinstall',
      run = function()
        local required_servers = { "rust", "json", "typescript", "vim", "elixir", "css", "html", "lua", "yaml", }
        local installed_servers = require'lspinstall'.installed_servers()

        for _, server in pairs(required_servers) do
          if not vim.tbl_contains(installed_servers, server) then
            require'lspinstall'.install_server(server)
          end
        end
      end
    }

    use {'neovim/nvim-lspconfig',
      requires = {
        -- config handled in config.lspconfig
        {'nvim-lua/lsp-status.nvim'},
        {'lukas-reineke/format.nvim'},
        {'ray-x/lsp_signature.nvim'},
        {'kabouzeid/nvim-lspinstall'},
        {'hrsh7th/vim-vsnip'},
        {'hrsh7th/nvim-cmp'},
      },
      config = function()
        -- Ok I really don't understand this. If I remove this function
        -- wrapper, then any local function defined within config/lspconfig
        -- won't be usable by the setup function. This makes no sense.
        require('config.lspconfig').setup()
      end
    }
  end,
  config = {
    display = {
      open_fn = require('packer.util').float
    },
    profile = {
      enable = true,
      threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
    }
  }
})
