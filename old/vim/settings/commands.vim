
augroup zthomas
  autocmd!
  autocmd BufLeave * silent! :wa
  autocmd FocusGained * checktime
  autocmd BufEnter * silent! e!

  autocmd FileType txt :setlocal spell spelllang=en_us
  autocmd FileType yaml :set wrap
  autocmd FileType json :let g:indentLine_enabled=0
  autocmd FileType json :set conceallevel=0
  autocmd BufRead,BufNewFile bash_profile set filetype=bash
  autocmd BufRead,BufNewFile bashrc set filetype=bash
augroup END
