local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function() 

  use 'michaeljsmith/vim-indent-object'
	use 'wbthomason/packer.nvim' 
  use 'elixir-editors/vim-elixir'

	use {
	  'nvim-telescope/telescope.nvim',
	  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
	  config = function()
		  require('telescope')
		  vim.api.nvim_set_keymap('n', '<Leader>p', ':Telescope find_files<cr>', {noremap = true, silent = true})
	  end
	}

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.cmd([[ au! BufRead,BufNewFile *.fish set filetype=fish ]])
      require('nvim-treesitter.configs').setup {
        ensure_installed = {'rust', 'elixir', 'lua', 'fish'},
        ignore_install = {},
        highlight = {
          enable = true,
          disable = {"elixir"}
        }
      }
    end
  }

  use {
    'airblade/vim-gitgutter',
    config = function()
      vim.api.nvim_exec([[
        set updatetime=100
        let g:gitgutter_map_keys = 0
        command! Gqf GitGutterQuickFix | copen
        nnoremap <Leader>gc :Gqf<CR>
        nnoremap <Leader>ga :GitGutterStageHunk<CR>
        nnoremap <Leader>gu :GitGutterUndoHunk<CR>
        nnoremap <Leader>gn :GitGutterNextHunk<CR>
        nnoremap <Leader>gp :GitGutterPrevHunk<CR>
        nnoremap <Leader>gs :GitGutterPreviewHunk<CR>
        omap ih <Plug>(GitGutterTextObjectInnerPending)
        omap ah <Plug>(GitGutterTextObjectOuterPending)
        xmap ih <Plug>(GitGutterTextObjectInnerVisual)
        xmap ah <Plug>(GitGutterTextObjectOuterVisual)
      ]], false)
    end
  }

  use {'gruvbox-community/gruvbox', 
    config = function()
      vim.cmd("colorscheme gruvbox")
    end
  }

  use {'neovim/nvim-lspconfig', 
    requires = {
      -- config handled in config.lspconfig
      {"ray-x/lsp_signature.nvim"},
      {'kabouzeid/nvim-lspinstall'},
      {'hrsh7th/vim-vsnip',
        requires = {{'hrsh7th/vim-vsnip-integ'}}
      },
      {'hrsh7th/nvim-compe',
          config = function()
            require('config.compe').setup()
          end
        }
    },
    config = function()
      require('config.lspconfig').setup()
    end
  }
end)
