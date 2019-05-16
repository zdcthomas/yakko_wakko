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

  Plug 'michaeljsmith/vim-indent-object'
  
  Plug 'morhetz/gruvbox'           " color scheme
  
  Plug 'sheerun/vim-polyglot'      " autoloaded multiple language support
  Plug 'terryma/vim-multiple-cursors'
  
  Plug 'tpope/vim-commentary'      " All Hail Tpope
  
  Plug 'tpope/vim-surround'        " Surround text with text
  " Plug 'tpope/vim-fugitive'
  
  Plug 'vim-airline/vim-airline'   " Status line
  Plug 'vim-airline/vim-airline-themes'

  Plug 'moll/vim-bbye'
call plug#end()

" =================================  EASYMOTION  ==========================================="
""  color of selectable letter background
if &runtimepath =~ 'vim-easymotion'
  hi link EasyMotionTarget Function
  hi link EasyMotionShade  Comment
  let g:EasyMotion_smartcase = 1
  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)
endif

" =================================  AIRLINE  ===========================================
if &runtimepath =~ 'vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'default'
endif

" =================================  BBYE  ===========================================
if &runtimepath =~ 'vim-bbye'
  nnoremap <Leader>q :Bdelete<CR>
endif

" =================================  POLYGLOT ===========================================
if &runtimepath =~ 'vim-polyglot'
  let g:polyglot_disabled = ['markdown']
endif

" =================================  EASY ALIGN ===========================================
if &runtimepath =~ 'vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" =================================  FZF  ==========================================="
if &runtimepath =~ 'fzf.vim'
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
endif


" =================================  FUGITIVE ==========================================="
if &runtimepath =~ 'vim-fugitive'
  nnoremap <leader>gb :Gblame<Cr>
  nnoremap <leader>gd :Gdiff<Cr>
  nnoremap <leader>gs :Gstatus<Cr>
  nnoremap <leader>gc :Gcommit<Cr>
  if executable('hub')
   nnoremap <leader>hub :!hub browse<Cr>
  endif
endif

" =================================  NNN   ==========================================="
if &runtimepath =~ 'nnn.vim'
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

" =================================  GITGUTTER  ===========================================
if &runtimepath =~ 'vim-gitgutter'
  set updatetime=100
  let g:gitgutter_map_keys = 0
  nnoremap <Leader>ga :GitGutterStageHunk<CR>
  nnoremap <Leader>gu :GitGutterUndoHunk<CR>
  nnoremap <Leader>gn :GitGutterNextHunk<CR>
  nnoremap <Leader>gp :GitGutterPrevHunk<CR>
  nnoremap <Leader>gs :GitGutterPreviewHunk<CR> 
endif

