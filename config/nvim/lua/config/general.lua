-- This file is for configs that are short. It's kind of dumb to seperate these
-- out not into their own files but for now it's what I'm trying.
local Config = {}

function Config.lualine()
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
      lualine_c = {'diff', "require'lsp-status'.status()"},
      lualine_x = {},
      lualine_y = {'branch'},
      lualine_z = {'filetype'},
    }
  }
  require('lualine').setup(config)
end

function Config.camelsnek()
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

function Config.autopairs()
  require('nvim-autopairs').setup{
    fast_wrap = {},
    check_ts = true,
  }
  require("nvim-autopairs.completion.cmp").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` after select function or method item
  })
end

function Config.dirvish()
  vim.g.loaded_netrwPlugin = 1
  vim.cmd([[
    command! -nargs=? -complete=dir Explore Dirvish <args>
    command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
    command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
  ]])
  vim.g.dirvish_mode=':sort | sort ,^.*[^/]$, r'
end

function Config.md_links()
  require('follow-md-links')
  vim.api.nvim_set_keymap('', '<bs>', ':edit #<cr>', {noremap = true, silent = true})
end

function Config.easy_align()
  vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})
  vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
end

function Config.git_signs()
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

return Config
