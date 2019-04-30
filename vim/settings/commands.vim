" vimrc hot reload
command! Svrc source $MYVIMRC
command! Vrc :tabnew ~/.vim/settings/settings.vim
command! Yf :let @+ = expand("%")


augroup zthomas
  autocmd!
  autocmd BufLeave * silent! :wa
  autocmd FocusGained * checktime
  autocmd BufEnter * silent! e!
augroup END


" function! s:IndObject(inner)
"   let curline_num = line('.')
"   let curr_indentation = indent(line("."))
"   if getline('.') !~ "^\\s*$"

"   endif
" endfunction

" function! s:SearchUpward(line, pattern)
"   let curr_line = line 
"   " line is x
"   " loop
"   "   check if match
"   "     break if match
"   "   line - 1
"   " end
"   if getline(curr_line) =~ pattern
"     return curr_line
"   endif

" endfunction

