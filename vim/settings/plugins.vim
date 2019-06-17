if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/z_plugins')

  Plug 'junegunn/vim-plug'         " The current plugin manager

  "=================================== TYPING ====================================================
  Plug 'Raimondi/delimitMate'      " autocompletion of closing tags

  Plug 'Yggdroot/indentLine'       " Display Indentation

  Plug 'easymotion/vim-easymotion' " great motion plugin

  Plug 'michaeljsmith/vim-indent-object'

  Plug 'junegunn/vim-easy-align'   " Eeasily align text on a specific character

  Plug 'tpope/vim-commentary'      " All Hail Tpope

  Plug 'tpope/vim-surround'        " Surround text with text

  Plug 'terryma/vim-multiple-cursors'


  "=================================== FILE ========================================================
  Plug 'mcchrish/nnn.vim'          " file management

  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'          " RTP and plugin for fzf finder

  " =================================== GIT ===============================================
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar
  " Plug 'tpope/vim-fugitive'


  "=================================== LANGUAGE =======================================================
  Plug 'sheerun/vim-polyglot'      " autoloaded multiple language support

  Plug 'chrisbra/Colorizer'


  "=================================== COMPLETION =======================================================
  Plug 'neoclide/coc.nvim', has('nvim') ? {'tag': '*', 'do': './install.sh'} : { 'on': [] }


  "=================================== STATUS LINE ====================================================
  Plug 'vim-airline/vim-airline'  
  Plug 'vim-airline/vim-airline-themes'


  "=================================== WINDOW ============================================================
  Plug 'moll/vim-bbye'

  Plug 'w0rp/ale'

  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'


  "=================================== COLOR SCHEMES =======================================================
  Plug 'gruvbox-community/gruvbox'    
  Plug 'sonph/onehalf', {'rtp': 'vim'}

call plug#end()

" ================================= EASYMOTION  ==========================================="
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

" =================================  COC  ===========================================
if &runtimepath =~ 'coc'
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? coc#_select_confirm() :
  "       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  "       \ <SID>check_back_space() ? "\<TAB>" :
  "       \ coc#refresh()

  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> K :call <SID>show_documentation()<CR>
endif


" =================================  ALE  ===========================================
if &runtimepath =~ 'ale'
  nnoremap gd :ALEGoToDefinition<CR>
  let g:ale_linters = {
  \   'typescript': ['eslint', 'tslint', 'tsserver', 'typecheck', 'xo'],
  \}
  let g:ale_linters_explicit = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
endif
