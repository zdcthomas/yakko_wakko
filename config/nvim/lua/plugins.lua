local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function() 

	use 'wbthomason/packer.nvim' 
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
  use {'gruvbox-community/gruvbox', 
    config = function()
      vim.cmd("colorscheme gruvbox")
    end
  }
  use {'nvim-lua/completion-nvim',
    config = function()
      vim.cmd([[
        " Use <Tab> and <S-Tab> to navigate through popup menu
        inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " Set completeopt to have a better completion experience
        set completeopt=menuone,noinsert,noselect

        " Avoid showing message extra message when using completion
        set shortmess+=c
      ]])
    end
  }

  use {
    'kabouzeid/nvim-lspinstall',
    config = function()
      require'lspinstall'.setup()
    end
  }

  use {'neovim/nvim-lspconfig', 

    requires = {{'nvim-lua/completion-nvim'}},
    config = function()
      vim.cmd([[ au! BufRead,BufNewFile *.rs set filetype=rust ]])
      vim.cmd([[ au! BufRead,BufNewFile *.ex set filetype=elixir ]])
      local nvim_lsp = require('lspconfig')
      local on_atach = function(client, bufnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = {silent = false, remap = true}
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      end

      local servers = { "elixirls", "rust_analyzer", "tsserver" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end
    end
  }
end)

