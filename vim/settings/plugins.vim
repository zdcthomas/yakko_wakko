if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/z_plugins')
  
  Plug 'Raimondi/delimitMate'      " autocompletion of closing tags
  
  Plug 'Yggdroot/indentLine'       " Display Indentation
  
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar
  
  Plug 'easymotion/vim-easymotion' " great motion plugin
  
  Plug 'junegunn/fzf.vim'          " RTP and plugin for fzf finder
  Plug '/usr/local/opt/fzf'

  Plug 'junegunn/vim-easy-align'   " Eeasily align text on a specific character
  
  Plug 'junegunn/vim-plug'         " The current plugin manager
  
  Plug 'mcchrish/nnn.vim'          " file management
  
  Plug 'morhetz/gruvbox'           " color scheme
  
  Plug 'sheerun/vim-polyglot'      " autoloaded multiple language support
  Plug 'terryma/vim-multiple-cursors'
  
  Plug 'tpope/vim-commentary'      " All Hail Tpope
  
  Plug 'tpope/vim-surround'        " Plug 'tpope/vim-fugitive'
  
  Plug 'vim-airline/vim-airline'   " status line
  Plug 'vim-airline/vim-airline-themes'

  Plug 'moll/vim-bbye'
call plug#end()

" =================================  EASYMOTION  ==========================================="
""  color of selectable letter background
hi link EasyMotionTarget Function
hi link EasyMotionShade  Comment
let g:EasyMotion_smartcase = 1
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" =================================  AIRLINE  ===========================================
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

" =================================  AIRLINE  ===========================================
nnoremap <Leader>q :Bdelete<CR>

" =================================  POLYGLOT ===========================================
let g:polyglot_disabled = ['markdown']

" =================================  EASY ALIGN ===========================================
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =================================  FZF  ==========================================="
set rtp+=/usr/local/opt/fzf
let g:fzf_buffers_jump = 1
nnoremap <silent> <Leader>p :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>c :Commits<CR>
nnoremap <silent> <Leader>F :Rg 
nnoremap <silent> <Leader>: :Commands<CR>
nnoremap <silent> <Leader><Leader><Leader> :Maps<CR>

" preview for files
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" =================================  FUGITIVE ==========================================="
" nnoremap <leader>gb :Gblame<Cr>
" nnoremap <leader>gd :Gdiff<Cr>
" nnoremap <leader>gs :Gstatus<Cr>
" nnoremap <leader>gc :Gcommit<Cr>
" if executable('hub')
"  nnoremap <leader>hub :!hub browse<Cr>
" endif


" =================================  NNN   ==========================================="
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

" =================================  GITGUTTER  ===========================================
set updatetime=100

" reminder of keybindings
" ]c  [c  next change, previous change
" <Leader>hp preview hunk
" <Leader>hu undo hunk
" <Leader>hs stage hunk

