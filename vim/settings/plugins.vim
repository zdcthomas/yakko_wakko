function! HasPlug(plugin)
  let path_to_splugins="~/.vim/pack/zthomas/start/"
  return finddir("plugin", path_to_splugins.a:plugin)
endfunction

if HasPlug("vim-easymotion")
  " Easymotion 
    " color of selectable letter background
  hi link EasyMotionTarget Function
  hi link EasyMotionShade  Comment
  let g:EasyMotion_smartcase = 1
  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)
endif

if HasPlug("fzf.vim")
  "fzf 
  set rtp+=/usr/local/opt/fzf
  let g:fzf_buffers_jump = 1
  nnoremap <silent> <Leader>p :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
endif

if HasPlug("vim-fugitive")
  " fugitive 
  nnoremap <leader>gb :Gblame<Cr>
  nnoremap <leader>gd :Gdiff<Cr>
  nnoremap <leader>gs :Gstatus<Cr>
  nnoremap <leader>gc :Gcommit<Cr>
  if executable('hub')
    nnoremap <leader>hub :!hub browse<Cr>
  endif
end

if HasPlug("nnn.vim")
  " NNN configuration
  " let $NNN_TMPFILE="/tmp/nnn"
  let g:nnn#command = 'nnn -l'
  let g:nnn#replace_netrw=1
  let g:nnn#set_default_mappings = 0
  nnoremap - :call nnn#pick('%:p:h', {'layout': 'enew', 'edit': 'tabnew'})<Cr>
  nnoremap <leader>n :NnnPicker '%:p:h'<CR>
  let g:nnn#layout = { 'left': '~20%' }
  let g:nnn#action = {
      \ '<c-l>': 'vsplit',
      \ '<c-t>': 'tab split',
      \ '<c-j>': 'split' }
endif

if HasPlug("vim-gitgutter")
  " gitgutter
  set updatetime=100
  " reminder of keybindings
  " ]c  [c  next change, previous change
  " <Leader>hp preview hunk
  " <Leader>hu undo hunk
  " <Leader>hs stage hunk
endif


if exists('veonim')
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-surround'

  " extensions for web dev
  let g:vscode_extensions = [
    \'vscode.typescript-language-features',
    \'vscode.css-language-features',
    \'vscode.html-language-features',
  \]
endif
