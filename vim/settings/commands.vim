function! TmuxSend(direction, command, text)
  let to_send = a:command . " " . a:text
  let full_command = "!tmux send-keys -t " . a:direction . " '" . to_send . "'" ." Enter"
  silent echom full_command
  " Thanks @Jimgerneer
  let clear_command = "!tmux send-keys -t " . a:direction . " C-c". " Enter"
  silent execute clear_command 
  silent execute full_command
endfunction

function! GitUnStagedChanges()
  let list = []
    let command = "git --no-pager diff --no-ext-diff --no-color -U0 
          \ | sed 's/diff --git//g' 
          \ | sed 's/a\\/.* //g' 
          \ | sed 's/^ b/\\./' 
          \ | sed '/index /d' 
          \ | sed '/--- a/d' 
          \ | sed '/+++ b/d' 
          \ | sed '/^[+-]/d' 
          \ | sed 's/^@@.*+/:/g' 
          \ | sed 's/ @@ /|#|/g' 
          \ | sed 's/,.*|#|/|#|/g' 
          \ | sed 's/\\.\\/.*$/|+|&/g' 
          \ | sed 's/^:/|-|/' "
    let diffed = system(command)
    let files = split(diffed, "|+|")
    for f in files
      let one_file_with_lines = split(f, "|-|")
      let this_file = split(one_file_with_lines[0])[0]
      let lines = one_file_with_lines[1:]
      for l in lines
        let [lnum, text] = split(l, "|#|")
        let thingy = {"filename": this_file, "lnum": lnum, "text": text}
        call add(list, thingy)
      endfor
    endfor
    call setqflist(list)
    copen
endfunction

nnoremap <Leader>gc :call GitUnStagedChanges()<Cr>
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

  autocmd FileType elixir :ab bind require IEx;IEx.pry
  autocmd FileType elixir :nnoremap <Leader>tl :call TmuxSend("right", "mix", "%")<Cr>
  autocmd BufWritePost *.exs,*.ex silent :!mix format %
  autocmd FileType ruby :ab bind require 'pry';binding.pry
  autocmd FileType ruby :nnoremap <Leader>tl :call TmuxSend("right", "rspec", "%")<Cr>
  autocmd FileType ruby :nnoremap <Leader>ttl :call TmuxSend("right", "rspec", expand("%") . ":" . line('.'))<Cr>
  autocmd WinEnter * set colorcolumn=110
  autocmd WinLeave * set colorcolumn=0
  autocmd FileType yaml :set wrap
  autocmd FileType *.json :set conceallevel=0
augroup END
