" vimrc hot reload
command! Svrc source $MYVIMRC
command! Vrc :tabnew ~/.vim/settings/settings.vim
command! Yf :let @+ = expand("%")
command! Test :! tmux select-pane -R; tmux send-keys "rspec " % C-m


augroup zthomas
  autocmd!
  autocmd BufLeave * silent! :wa
  autocmd FocusGained * checktime
  autocmd BufEnter * silent! e!
  if has('nvim')
    autocmd TextYankPost * 
  endif

  " autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=4000
  " autocmd InsertLeave * let &updatetime=updaterestore
  " autocmd CursorHoldI * stopinsert
augroup END

" function! TestFile()
"   let current_file=expand("@%")
"   tmux select-pane -t 1; tmux send-keys "rspec " + current_file

" endfunction

function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction

function! CleverShiftTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<s-Tab>"
   else
      return "\<C-P>"
   endif
endfunction

inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <s-tab> <C-R>=CleverShiftTab()<CR>



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

