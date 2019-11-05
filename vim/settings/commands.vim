function! TmuxSend(direction, command, text)
  let to_send = a:command . " " . a:text
  let full_command = "!tmux send-keys -t " . a:direction . " '" . to_send . "'" ." Enter"
  silent echom full_command
  " Thanks @Jimgerneer
  let clear_command = "!tmux send-keys -t " . a:direction . " C-c". " Enter"
  silent execute clear_command 
  silent execute full_command
endfunction

function! GitUncommitedChanges()
  let flist = systemlist("git status --porcelain | sed 's/M //g'")
  let list = []
  for f in flist
    " git blame is the easiest comamnd I found that actually gives back line
    " numbers.
    let command = "git blame " . f . " -nf 
          \ | grep 'Not Committed Yet' 
          \ | sed 's/^[0..9,a..z]* //g' 
          \ | sed 's/(.*//g' "
    let blamed_lines = system(command)
    let split = split(blamed_lines)
    if len(split) != 0
      let dic = { "filename": split[0], "lnum": split[1] }
    else
      " If the only change is a deletion, git blame won't pick it up, so
      " instead we just have to put the file name in, this isn't ideal.
      let filename = trim(f)
      let dic = { "filename": filename}
    endif
    call add(list, dic)
  endfor
  " This sets the quickfix list, with 'list' being a list of dictionaries that
  " have filename, line number, model etc.
  call setqflist(list)
  copen
endfunction
nnoremap <Leader>gc :silent call GitUncommitedChanges()<Cr>

" vimrc hot reload
command! Svrc source $MYVIMRC
command! Vrc :tabnew ~/.vim/settings/settings.vim
command! Yf :let @+ = expand("%")
command! -range GitBlame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n") 
nnoremap <Leader>gb :GitBlame<Cr>
nnoremap <Leader>gb :GitBlame<Cr>
nnoremap <Leader>yf :Yf<Cr>
vnoremap gb :GitBlame<Cr>


augroup zthomas
  autocmd!
  autocmd BufLeave * silent! :wa
  autocmd FocusGained * checktime
  autocmd BufEnter * silent! e!
  autocmd VimEnter * hi Normal ctermbg=none

  autocmd FileType elixir :ab pry require IEx;IEx.pry
  autocmd FileType elixir :nnoremap <Leader>tl :call TmuxSend("right", "mix", "%")<Cr>
  autocmd FileType ruby :ab pry require 'pry';binding.pry
  autocmd FileType ruby :nnoremap <Leader>tl :call TmuxSend("right", "rspec", "%")<Cr>
  autocmd FileType ruby :nnoremap <Leader>ttl :call TmuxSend("right", "rspec", expand("%") . ":" . line('.'))<Cr>
  autocmd WinEnter * set colorcolumn=110
  autocmd WinLeave * set colorcolumn=0
  autocmd FileType yaml :set wrap
augroup END
