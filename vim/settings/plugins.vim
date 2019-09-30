if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/z_plugins')

  Plug 'junegunn/vim-plug'         " The current plugin manager

  "=================================== TYPING =============================================
  Plug 'Raimondi/delimitMate'      " autocompletion of closing tags

  Plug 'Yggdroot/indentLine'       " Display Indentation

  Plug 'easymotion/vim-easymotion' " great motion plugin

  Plug 'michaeljsmith/vim-indent-object'

  Plug 'junegunn/vim-easy-align'   " Eeasily align text on a specific character

  Plug 'tpope/vim-commentary'      " All Hail Tpope

  Plug 'tpope/vim-surround'        " Surround text with text

  Plug 'terryma/vim-multiple-cursors'

  Plug 'dhruvasagar/vim-table-mode'

  Plug 'gyim/vim-boxdraw'          " Draw some boxes


  "=================================== FILE ================================================
  Plug 'francoiscabrol/ranger.vim' "File management

  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'          " RTP and plugin for fzf finder

  " =================================== GIT ================================================
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar

  "=================================== LANGUAGE ============================================
  Plug 'sheerun/vim-polyglot'      " autoloaded multiple language support

  Plug 'chrisbra/Colorizer'

  Plug 'JamshedVesuna/vim-markdown-preview'

  "=================================== COMPLETION ==========================================
  Plug 'neoclide/coc.nvim', has('nvim') ? {'tag': '*', 'do': './install.sh'} : { 'on': [] }

  " Plug 'w0rp/ale'

  "=================================== STATUS LINE =========================================
  Plug 'vim-airline/vim-airline'  
  Plug 'vim-airline/vim-airline-themes'

  "=================================== WINDOW ==============================================
  Plug 'moll/vim-bbye'

  Plug 'junegunn/goyo.vim'

  Plug 'segeljakt/vim-silicon'
  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'    
  Plug 'sonph/onehalf', {'rtp': 'vim'}
  Plug 'dylanaraps/wal'

  Plug 'mhinz/vim-startify'

  "=================================== PERSONAL PLUGINS ======================================
  Plug 'zdcthomas/vish' "vim fish without the slow stuff

call plug#end()

" ================================= EASYMOTION ===========================================
""  color of selectable letter background
if &runtimepath =~ 'vim-easymotion'
  hi link EasyMotionTarget Function
  hi link EasyMotionShade  Comment
  let g:EasyMotion_smartcase = 1
  map  <Leader><Leader>/ <Plug>(easymotion-sn)
  omap <Leader><Leader>/ <Plug>(easymotion-tn)
endif

if &runtimepath =~ 'startify'
  let g:startify_lists = [{ 'type': 'dir',       'header': ['   MRU '. getcwd()] }]
        " \ { 'type': 'files',     'header': ['   MRU']            }]

  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:ascii = [
        \ '        __',
        \ '.--.--.|__|.--------.',
        \ '|  |  ||  ||        |',
        \ ' \___/ |__||__|__|__|',
        \ ''
        \]

			" [
			" \'             &&',
			" \'           &&&&&',
			" \'         &&&\/& &&&',
			" \'        &&|,/  |/& &&',
			" \'         &&/   /  /_&  &&',
			" \'           \  {  |_____/_&',
			" \'           {  / /          &&&',
			" \'           `, \{___________/_&&',
			" \'            } }{       \',
			" \'            }{{         \____&',
			" \'           {}{           `&\&&',
			" \'           {{}             &&',
			" \'     , -=-~{ .-^- _',
			" \'           `}',
			" \'            {',
			" \]
  let g:startify_custom_header = g:ascii
  let g:startify_disable_at_vimenter = 1
endif

" ================================= AIRLINE =============================================
if &runtimepath =~ 'vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'default'
endif

" ================================= BBYE ================================================
if &runtimepath =~ 'vim-bbye'
  command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
  nnoremap <Leader>q :Bdelete<CR>
endif

" ================================= POLYGLOT =============================================
if &runtimepath =~ 'vim-polyglot'
  let g:polyglot_disabled = ['markdown', 'fish', 'json', 'rails', 'ruby'] "Some of these are just so slow
endif
" ================================= EASY ALIGN ===========================================
if &runtimepath =~ 'vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" ================================= FZF =================================================
if &runtimepath =~ 'fzf.vim'
  set rtp+=/usr/local/opt/fzf
  let g:fzf_buffers_jump = 1
  nnoremap <silent> <Leader>p :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>G :Lines<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
  " note: THERE'S SOME WHITESPACE AT THE END OF \/THIS\/ LINE AND IT'S INTENTIONAL
  nnoremap <silent> <Leader>F :Rg 
  nnoremap <silent> <Leader>C :Colors<CR>
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
  nnoremap <Leader>d :ALEGoToDefinition<CR>
  let g:ale_linters = {
  \   'typescript': ['eslint', 'tslint', 'tsserver', 'typecheck', 'xo'],
  \   'elixir': ['credo', 'dialyxir', 'dogma', 'elixir-ls', 'mix'],
  \}
  let g:ale_linters_explicit = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 1
endif

if &runtimepath =~ 'gruvbox'
  colorscheme gruvbox
  if exists('$TMUX')
    hi Normal guibg=NONE
  endif
endif

if &runtimepath =~ 'ranger'
  let g:ranger_map_keys = 0
  nnoremap <Leader>n :Ranger<CR>

  let g:ranger_replace_netrw = 1
  let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
endif

if &runtimepath =~ 'markdown'
  let vim_markdown_preview_github=1

endif
