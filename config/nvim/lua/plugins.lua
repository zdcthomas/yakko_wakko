local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'

    use 'michaeljsmith/vim-indent-object'
    use 'tpope/vim-commentary'
    use '~/dev/boom'
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
      config = function ()
        vim.g.loaded_netrwPlugin = 1
        vim.cmd([[
          command! -nargs=? -complete=dir Explore Dirvish <args>
          command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
          command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
        ]])
        vim.g.dirvish_mode=':sort | sort ,^.*[^/]$, r'
      end
    }

    use {
      'nicwest/vim-camelsnek',
      config = function ()
        vim.g.camelsnek_alternative_camel_commands = 1

        vim.api.nvim_set_keymap('n', 'crs', ':Snek<CR>',   {noremap = true, silent = true})
        vim.api.nvim_set_keymap('x', 'crs', ':Snek<CR>',   {noremap = true, silent = true})

        vim.api.nvim_set_keymap('n', 'crp', ':Pascal<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('x', 'crp', ':Pascal<CR>', {noremap = true, silent = true})

        vim.api.nvim_set_keymap('n', 'crc', ':Camel<CR>',  {noremap = true, silent = true})
        vim.api.nvim_set_keymap('x', 'crc', ':Camel<CR>',  {noremap = true, silent = true})

        vim.api.nvim_set_keymap('n', 'crk', ':Kebab<CR>',  {noremap = true, silent = true})
        vim.api.nvim_set_keymap('x', 'crk', ':Kebab<CR>',  {noremap = true, silent = true})
      end
    }

    use {
      disable = true,
      'elixir-editors/vim-elixir',
      ft = {'elixir'}
    }

    use {
      'windwp/nvim-autopairs',
      on = "InsertEnter",
      config = function ()
        require('nvim-autopairs').setup{
          fast_wrap = {},
          check_ts = true,
        }
        require("nvim-autopairs.completion.cmp").setup({
          map_cr = true, --  map <CR> on insert mode
          map_complete = true, -- it will auto insert `(` after select function or method item
        })
      end
    }

    use {
      'jghauser/follow-md-links.nvim',
      ft = {'markdown'},
      config = function()
        require('follow-md-links')
        vim.api.nvim_set_keymap('', '<bs>', ':edit #<cr>', {noremap = true, silent = true})
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
      config = function ()
        local config = {
          extensions = {'quickfix'},
          disabled_filetypes = {'startify'},
          options = {
            theme = 'codedark'
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {
              {
                'filename',
                file_status = true,
                path = 1
              }
            },
            lualine_c = {'diff', require('lsp-status').status},
            lualine_x = {},
            lualine_y = {'branch'},
            lualine_z = {'filetype'},
          }
        }
        require('lualine').setup(config)
      end
    }

    use {
      'junegunn/vim-easy-align',
      keys = {
        {'x', 'ga'},
        {'n', 'ga'},
      },
      cmd = 'EasyAlign',
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
      keys = {
        '<Leader>p',
        '<Leader>F',
        '<Leader>*',
      },
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      },
      cmd = {'Telescope'},
      config = function()
        require('telescope').setup {
          pickers = {
            find_files = {
              hidden = true,
              follow = true,
            }
          },
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
        vim.api.nvim_set_keymap('n', '<Leader>ww', ":lua require('telescope.builtin').file_browser({dir_icon = '', depth = 10, cwd = '~/irulan/wiki'})<cr>", {noremap = true, silent = true})
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
        vim.cmd([[ au! BufRead,BufNewFile *.fish set filetype=fish ]])
        require('nvim-treesitter.configs').setup {
          indent = {
            enable = true
          },
          {
            autopairs = {enable = true}
          },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
          },
          rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
          },
          ensure_installed = {
            'rust',
            'lua',
            'fish',
            'bash',
            'dockerfile',
            'comment',
            'graphql'
          },
          highlight = {
            enable = true,
          }
        }

        require "nvim-treesitter.parsers".get_parser_configs().markdown = {
          install_info = {
            url = "https://github.com/ikatyang/tree-sitter-markdown",
            files = {"src/parser.c", "src/scanner.cc"}
          },
          filetype = "markdown",
        }
      end
    }

    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function ()
        require('gitsigns').setup {
          signs = {
            add          = {hl = 'GitSignsAdd'   , text = '>', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
            change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
            delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          },
          numhl = true,
          keymaps = {
            ['n <leader>gn'] =  "<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>",
            ['n <leader>gp'] =  "<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>",
            ['n <leader>ga'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ['v <leader>ga'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>gr'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ['n <leader>gu'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>gs'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            ['n <leader>gc'] = '<cmd>lua require"gitsigns".setqflist("all")<CR>',
          }
        }
      end
    }

    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path'
      },
      config = function ()
        require('config.cmp').setup()
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
        {'nvim-lua/lsp-status.nvim'},
        {"ray-x/lsp_signature.nvim"},
        {'kabouzeid/nvim-lspinstall'},
        {'hrsh7th/vim-vsnip',
          requires = {{'hrsh7th/vim-vsnip-integ'}},
          config = function ()
            vim.g.vsnip_snippet_dir = "~/yakko_wakko/config/nvim/snippets"
            vim.g.vsnip_filetypes = {
              html_css = {'html', 'css'}
            }
          end
        },
        {'hrsh7th/nvim-cmp'},
        -- {'hrsh7th/nvim-compe',
        --   requires = {
        --     {'andersevenrud/compe-tmux'}
        --   },
        --   config = function()
        --     require('config.compe').setup()
        --   end
        -- }
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
