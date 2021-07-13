vim.api.nvim_exec([[
  let mapleader = " "
  function! SourceFile(file)
    if filereadable(expand(a:file))
      exe 'source' a:file
    endif
  endfunction
  call SourceFile("~/.vim/settings/settings.vim")
]], false)

vim.api.nvim_set_option('number', true)
vim.api.nvim_set_keymap('n', '<Leader>wl', ':vsp<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>wj', ':sp<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-W><C-J>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W><C-k>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W><C-l>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W><C-h>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Up>', ':res +5<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Down>', ':res -5<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Left>', ':vertical resize -5<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Right>', ':vertical resize +5<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-n>', ":let @/=expand('<cword>')<cr>cgn", {noremap = true, silent = true})

vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', {noremap = true})
vim.api.nvim_set_keymap('c', '<C-e>', '<End>', {noremap = true})

vim.api.nvim_set_keymap('i', '<C-A>', '<c-o>^', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-B>', '<Left>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-F>', '<Right>', {noremap = true})
vim.api.nvim_set_keymap('i', '<A-f>', '<Esc>lwi', {noremap = true})
vim.api.nvim_set_keymap('i', '<A-b>', '<Esc>bi', {noremap = true})

require('plugins')
