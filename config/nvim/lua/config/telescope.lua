local conf = {}

function conf.setup()
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

return conf
