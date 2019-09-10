function! SendRight(text)
  !tmux select-pane -R
  !tmux send-keys C-l
  echom system("tmux send-keys " . a:text, "C-m")
endfunction

" vimrc hot reload
command! Svrc source $MYVIMRC
command! Vrc :tabnew ~/.vim/settings/settings.vim
command! Yf :let @+ = expand("%")
command! Test :SendRight("rspec")
" command! Log :call SendRight("git   log") 
command! -range GitBlame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n") 
" nnoremap <Leader>gl :Log<Cr>
nnoremap <Leader>gb :GitBlame<Cr>
nnoremap <Leader>yf :Yf<Cr>
vnoremap gb :GitBlame<Cr>


augroup zthomas
  autocmd!
  autocmd BufLeave * silent! :wa
  autocmd FocusGained * checktime
  autocmd BufEnter * silent! e!
  autocmd VimEnter * hi Normal ctermbg=none

  " Highlighting active window
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul

  " transparency on cursorline
  " autocmd FocusGained * :set cursorline
  " autocmd FocusLost * :set nocursorline

augroup END
