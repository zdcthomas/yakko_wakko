local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(
  {function(use)
    use 'wbthomason/packer.nvim'
    use {'itchyny/lightline.vim',
      config = function()
        vim.cmd([[call SourceFile("~/.vim/settings/plugins/lightline.vim")]])
      end
    }

    use 'michaeljsmith/vim-indent-object'
    use 'elixir-editors/vim-elixir'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'sainnhe/everforest'
    use 'rhysd/vim-color-spring-night'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      },
      config = function()
        require('telescope').setup {
          extensions = {
            fzf = {
              fuzzy = true,                    -- false will only do exact matching
              override_generic_sorter = false, -- override the generic sorter
              override_file_sorter = true,     -- override the file sorter
              case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                               -- the default case_mode is "smart_case"
            }
          }
        }
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        require('telescope').load_extension('fzf')
        vim.api.nvim_set_keymap('n', '<Leader>p', ':Telescope find_files<cr>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>F', ':Telescope live_grep<cr>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>*', ':Telescope grep_stringlive_grep<cr>', {noremap = true, silent = true})
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

    use {
      'ray-x/navigator.lua',
      requires = {'ray-x/guihua.lua',
      run = 'cd lua/fzy && make'}
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
