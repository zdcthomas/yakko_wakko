if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugins')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'Raimondi/delimitMate'

Plug 'morhetz/gruvbox'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'Yggdroot/indentLine'

Plug 'mcchrish/nnn.vim'

Plug 'vim-airline/vim-airline'

Plug 'easymotion/vim-easymotion'

Plug 'terryma/vim-multiple-cursors'

Plug 'sheerun/vim-polyglot'

call plug#end()



   " Easymotion 
   ""  color of selectable letter background
   hi link EasyMotionTarget Function
   hi link EasyMotionShade  Comment
   let g:EasyMotion_smartcase = 1
   map  / <Plug>(easymotion-sn)
   omap / <Plug>(easymotion-tn)
 
   "fzf 
   set rtp+=/usr/local/opt/fzf
   let g:fzf_buffers_jump = 1
   nnoremap <silent> <Leader>p :Files<CR>
   nnoremap <silent> <Leader>b :Buffers<CR>
   nnoremap <silent> <Leader>c :Commits<CR>
   nnoremap <silent> <Leader>F :Ag<CR>
   nnoremap <silent> <Leader>: :Commands<CR>
   nnoremap <silent> <Leader><Leader><Leader> :Maps<CR>
 
   " fugitive 
   nnoremap <leader>gb :Gblame<Cr>
   nnoremap <leader>gd :Gdiff<Cr>
   nnoremap <leader>gs :Gstatus<Cr>
   nnoremap <leader>gc :Gcommit<Cr>
   if executable('hub')
     nnoremap <leader>hub :!hub browse<Cr>
   endif
 
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
 
   " gitgutter
   set updatetime=100
   " reminder of keybindings
   " ]c  [c  next change, previous change
   " <Leader>hp preview hunk
   " <Leader>hu undo hunk
   " <Leader>hs stage hunk
 
