vim.cmd("setlocal spell")
vim.api.nvim_buf_set_keymap('0', 'n', '<cr>', ':lua require("plugins.markdown_follow_link").follow_link(\". expand(\"<cword>\") .\")<cr>', {noremap = true})
