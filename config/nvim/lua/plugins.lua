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

    use {'lewis6991/impatient.nvim'}

    use 'michaeljsmith/vim-indent-object'

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
      'mattn/emmet-vim',
      ft = 'html'
    }

    use {
      'seandewar/nvimesweeper',
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
      'Julian/vim-textobj-variable-segment',
      requires = {
        'kana/vim-textobj-user',
      },
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
      'sindrets/winshift.nvim',
      keys = {"<leade>wm"},
      cmd = {"WinShift"},
      config = function ()
        require("winshift").setup({
          highlight_moving_win = true,  -- Highlight the window being moved
          focused_hl_group = "Visual",  -- The highlight group used for the moving window
          moving_win_options = {
            -- These are local options applied to the moving window while it's
            -- being moved. They are unset when you leave Win-Move mode.
            wrap = false,
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = "",
          }
        })
        vim.api.nvim_set_keymap('n', '<Leader>wm', '<Cmd>WinShift<CR>', {noremap = true, silent = true})
      end
    }

    use {
      'nvim-telescope/telescope.nvim',
      keys = {
        '<Leader>p',
        '<Leader>F',
        '<Leader>*',
        '<Leader>wp',
        '<Leader><Leader>q',
        '<Leader>ca',
        '<Leader>/',
        'gd',
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
      'segeljakt/vim-silicon',
      cmd = {"Silicon"}
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
      'jbyuki/venn.nvim',
      keys = {"<Leader>v"},
      config = function()
        -- enable or disable keymappings for venn
        function _G.toggle_venn()
          local venn_enabled = vim.inspect(vim.b.venn_enabled)
          if(venn_enabled == "nil") then
            vim.b.venn_enabled = true
            vim.cmd[[setlocal ve=all]]
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", {noremap = true})
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", {noremap = true})
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", {noremap = true})
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", {noremap = true})
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", {noremap = true})
          else
            vim.cmd[[setlocal ve=]]
            vim.cmd[[mapclear <buffer>]]
            vim.b.venn_enabled = nil
          end
        end
        -- toggle keymappings for venn using <leader>v
        vim.api.nvim_set_keymap('n', '<leader>v', ":lua toggle_venn()<cr>", { noremap = true})
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
      '~/dev/wiki.vim',
      config = function()
        vim.g.wiki_root = "~/irulan/wiki"
        vim.g.wiki_filetypes = {"md"}
        vim.g.wiki_link_extension = '.md'
        vim.g.wiki_link_target_type = 'md'
      end
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
      -- Configured servers list: vim, css, rust, json, typescript, elixir, lua, html, yaml
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
        {'kosayoda/nvim-lightbulb'},
        {'ray-x/lsp_signature.nvim'},
        {'kabouzeid/nvim-lspinstall'},
        {'onsails/vimway-lsp-diag.nvim'},
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
    },
  }
})
