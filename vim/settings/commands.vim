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
  autocmd VimEnter * hi Normal ctermbg=none
  " transparency on cursorline
  autocmd FocusGained * :set cursorline
  autocmd FocusLost * :set nocursorline


  " autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=4000
  " autocmd InsertLeave * let &updatetime=updaterestore
  " autocmd CursorHoldI * stopinsert
augroup END

" function! TestFile()
"   let current_file=expand("@%")
"   tmux select-pane -t 1; tmux send-keys "rspec " + current_file

" endfunction

