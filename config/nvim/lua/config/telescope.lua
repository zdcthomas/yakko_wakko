local conf = {}

local local_insert_symbol_i = function(prompt_bufnr)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  print("prompt_bufnr", prompt_bufnr)
  local symbol = action_state.get_selected_entry().value

  print('telescope:9 -> action_state.get_selected_entry().value', action_state.get_selected_entry().value)
  actions._close(prompt_bufnr, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { symbol })
  vim.schedule(function()
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #symbol })
  end)
end



function conf.setup()
  require('telescope').setup {
    pickers = {
      find_files = {
        hidden = true,
        follow = true,
        mappings = {
          i = {
            ["<c-i>"] = local_insert_symbol_i,
          },
        }
      }
    },
    defaults = {
      dynamic_preview_title = true,
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
  local default_opts = {noremap = true, silent = true}
  vim.api.nvim_set_keymap('n', '<leader>p', "<cmd>lua require'telescope.builtin'.find_files({ path_display = {'smart'}, find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", default_opts)
  vim.api.nvim_set_keymap('n', '<Leader>F', ':Telescope live_grep<cr>', default_opts)
  vim.api.nvim_set_keymap('n', '<Leader>*', ':Telescope grep_string<cr>', default_opts)
  vim.api.nvim_set_keymap('n', '<Leader>wp', ":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({cwd = '~/irulan/wiki'}))<cr>", default_opts)
  vim.api.nvim_set_keymap('i', ';', "<C-o>:lua require('telescope.builtin').find_files()<cr>", default_opts)
end

function conf.lsp_bindings_for_buffer(bufnr)
  local opts = {silent = false, noremap = true}
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  buf_set_keymap('n', '<Leader><Leader>q', '<Cmd>lua require("telescope.builtin").lsp_workspace_diagnostics(require("telescope.themes").get_ivy())<cr>', opts)
  buf_set_keymap('n', '<Leader>ca',        '<Cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor({initial_mode = "normal", winblend = 20}))<cr>',          opts)
  buf_set_keymap('n', '<Leader>/',         '<Cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>',      opts)
  buf_set_keymap('n', 'gd',                '<Cmd>lua require("telescope.builtin").lsp_definitions()<cr>',           opts)
  -- buf_set_keymap('x', '<Leader>ca',        '<Cmd>lua require("telescope.builtin").lsp_range_code_actions()<cr>',    opts)
end

return conf
