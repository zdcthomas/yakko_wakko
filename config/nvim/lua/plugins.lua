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
    use {'junegunn/vim-easy-align',
      config = function ()
        vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})
        vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
      end
    }

    use {'mhinz/vim-startify',
      config = function ()
        vim.g.startify_commands = {
            {p = {'Files',          ':Telescope find_files'}},
            {s = {'Sync Packer',    ':PackerSync'}},
            {c = {'Compile Packer', ':PackerCompile'}},
            {d = {'Open dotfiles',  ':!dmux ~/yakko_wakko'}},
            {D = {'Dmux',           ':!dmux'}},
        }
        vim.g.startify_lists = {
          {type = "commands", header = {'   めいれい '}},
          {type = "dir",      header = {'   MRU ' .. vim.fn.getcwd()}},
        }
        vim.g.sttartify_change_to_dir = 0
        vim.g.startify_change_to_vcs_root = 1
        local ascii = {
        [[             &&]],
        [[           &&&&&]],
        [[         &&&\/& &&&]],
        [[        &&|,/  |/& &&]],
        [[     *&_ &&/   /  /_&  &&]],
        [[    &_\\    \\  { &|__&_&/_&]],
        [[       \\_&_{*&/ /          &&&]],
        [[    ,      `, \{__&_&__&_&_/_&&]],
        [[   &        } }{      &\\']],
        [[            }{{         \'_&__&]],
        [[           {}{           \ `&\&&]],
        [[           {{}             '&&]],
        [[     ,--=-~{ .-^-\_,_         ]],
        [[ &,        `}                 ]],
        [[   .        { ]]
        }
        vim.g.startify_custom_header = ascii

      end
    }

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      },
      on = {'Telescope'},
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
        vim.api.nvim_set_keymap('n', '<Leader>*', ':Telescope grep_string<cr>', {noremap = true, silent = true})
      end
    }

    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'p00f/nvim-ts-rainbow',
        'nvim-treesitter/playground'
      },
      config = function()
        vim.cmd([[ au! BufRead,BufNewFile *.fish set filetype=fish ]])
        require('nvim-treesitter.configs').setup {
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
            colors = {}, -- table of hex strings
            termcolors = {} -- table of colour name strings
          },
          ensure_installed = {
            'rust',
            'elixir',
            'lua',
            'fish',
            'bash',
            'dockerfile',
            'comment',
            'graphql'
          },
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
        vim.g.gitgutter_map_keys = 0
        vim.api.nvim_set_keymap('n', '<Leader>ga', ':GitGutterStageHunk<CR>',   {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>gu', ':GitGutterUndoHunk<CR>',    {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>gn', ':GitGutterNextHunk<CR>',    {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>gp', ':GitGutterPrevHunk<CR>',    {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<Leader>gs', ':GitGutterPreviewHunk<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('o', 'ih',         '<Plug>(GitGutterTextObjectInnerPending)', {})
        vim.api.nvim_set_keymap('o', 'ah',         '<Plug>(GitGutterTextObjectOuterPending)', {})
        vim.api.nvim_set_keymap('x', 'ih',         '<Plug>(GitGutterTextObjectInnerVisual)', {})
        vim.api.nvim_set_keymap('x', 'ah',         '<Plug>(GitGutterTextObjectOuterVisual)', {})
        vim.cmd([[
          command! Gqf GitGutterQuickFix | copen
          nnoremap <Leader>gc :Gqf<CR>
        ]])
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
