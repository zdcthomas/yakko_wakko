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

  " Highlighting active window
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul

  " transparency on cursorline
  " autocmd FocusGained * :set cursorline
  " autocmd FocusLost * :set nocursorline

augroup END
