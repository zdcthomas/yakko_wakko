if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/z_plugins')

  Plug 'junegunn/vim-plug'         " The current plugin manager
"=================================== Text Editing ================================================
  Plug 'Raimondi/delimitMate'      " autocompletion of closing tags

  Plug 'Yggdroot/indentLine'       " Display Indentation

  Plug 'easymotion/vim-easymotion' " great motion plugin

  Plug 'michaeljsmith/vim-indent-object'

  Plug 'junegunn/vim-easy-align'   " Eeasily align text on a specific character

  Plug 'tpope/vim-commentary'      " All Hail Tpope
  Plug 'tpope/vim-abolish'

  Plug 'tpope/vim-surround'        " Surround text with text

  " Plug 'terryma/vim-multiple-cursors'

  "============== Lesser used ===============
  " Plug 'dhruvasagar/vim-table-mode'

  "=================================== FILE ================================================
  Plug 'francoiscabrol/ranger.vim' "File management

  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'          " RTP and plugin for fzf finder

  " =================================== GIT ================================================
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar

  "=================================== LANGUAGE ============================================
  " Plug 'andys8/vim-elm-syntax'
  Plug 'Zaptic/elm-vim'
  Plug 'chrisbra/Colorizer'
  Plug 'elixir-editors/vim-elixir'
  Plug 'rust-lang/rust.vim'
  Plug 'tpope/vim-scriptease'

  "=================================== COMPLETION ==========================================
  Plug 'neoclide/coc.nvim', has('nvim') ? {'tag': '*', 'branch': 'release'} : { 'on': [] }

  "=================================== STATUS LINE =========================================
  Plug 'vim-airline/vim-airline'  
  Plug 'vim-airline/vim-airline-themes'

  "=================================== WINDOW ==============================================
  Plug 'moll/vim-bbye'

  Plug 'segeljakt/vim-silicon'
  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'    
  Plug 'sonph/onehalf', {'rtp': 'vim'}
  Plug 'dylanaraps/wal'


  
  "=================================== UI =================================================
  Plug 'mhinz/vim-startify'
  "=================================== PERSONAL PLUGINS ===================================
  Plug 'zdcthomas/vish' "vim fish without the slow stuff

call plug#end()

if &runtimepath =~ 'delimit'
  let g:delimitMate_expand_space = 1
  let g:delimitMate_expand_cr = 2
endif

" =================================  COC  ===========================================
if &runtimepath =~ 'coc'
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_previous = '<c-k>'
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> gd :call CocAction('jumpDefinition')<Cr>
  nnoremap <silent> <Leader>gdl :call CocAction('jumpDefinition', 'vsplit')<Cr>
  nnoremap <silent> <Leader>gdj :call CocAction('jumpDefinition', 'split')<Cr>
  nnoremap <silent> gh :call CocAction('doHover')<Cr>
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <Leader>rn <Plug>(coc-rename)
  let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-rls', 'coc-marketplace', 'coc-elixir']
endif

" ================================= EASYMOTION ===========================================
""  color of selectable letter background
if &runtimepath =~ 'vim-easymotion'
  let g:EasyMotion_smartcase = 1
  hi link EasyMotionTarget Function
  hi link EasyMotionShade  Comment
  nmap <Leader>s <Plug>(easymotion-overwin-f2)
  map <Leader> <Plug>(easymotion-prefix)
  map  <Leader>/ <Plug>(easymotion-sn)
  omap <Leader>/ <Plug>(easymotion-tn)
endif

if &runtimepath =~ 'elm-vim'
  let g:elm_setup_keybindings = 0
endif

if &runtimepath =~ 'startify'
  let g:startify_lists = [{ 'type': 'dir',       'header': ['   MRU '. getcwd()] }]
        " \ { 'type': 'files',     'header': ['   MRU']            }]

  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:ascii = [
			\"             &&",
			\"           &&&&&",
			\"         &&&\/& &&&",
			\"        &&|,/  |/& &&",
			\"     *&_ &&/   /  /_&  &&",
			\"    &_\\    \\  {  |_____/_&",
			\"       \\_&_{*&/ /          &&&",
			\"           `, \{__&_&____&_/_&&",
			\"            } }{       \\'",
			\"            }{{         \'_&__&",
			\"           {}{           \\`&\&&",
			\"           {{}            \'&&",
			\"     , -=-~{ .-^- _",
			\"           `}",
			\"            {"
			\]
  let g:startify_custom_header = g:ascii
endif

" ================================= INDENTLINE =============================================
if &runtimepath =~ 'indent'
  let g:indentLine_enabled = 0
  nnoremap <Leader>it :IndentLinesToggle<Cr>
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
  nnoremap <silent> <Leader>gf :GFiles?<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
  " Maybe make this a thing that asks for input ||    ||
  " note: THERE'S SOME WHITESPACE AT THE END OF \/THIS\/ LINE AND IT'S INTENTIONAL
  nnoremap <silent> <Leader>F :Rg 
  nnoremap <silent> <Leader>C :Colors<CR>
  nnoremap <silent> <Leader>: :Commands<CR>
  nnoremap <silent> <Leader><Leader><Leader> :Maps<CR>
  if has('nvim')
    let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

    function! FloatingFZF()
      let width = float2nr(&columns * 0.9)
      let height = float2nr(&lines * 0.6)
      let opts = { 'relative': 'editor',
                 \ 'row': (&lines - height) / 2,
                 \ 'col': (&columns - width) / 2,
                 \ 'width': width,
                 \ 'height': height }

      let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
      call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
    endfunction

    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  endif
  " preview for files
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)
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



" =================================  ALE  ===========================================
if &runtimepath =~ 'ale'
  nnoremap <Leader>d :ALEGoToDefinition<CR>
  let g:ale_linters = {
  \   'typescript': ['eslint', 'tslint', 'tsserver', 'typecheck', 'xo'],
  \   'elixir': ['credo', 'dialyxir', 'dogma', 'elixir-ls', 'mix'],
  \}
  " let g:ale_linters_explicit = 1
  " let g:ale_lint_on_text_changed = 'never'
  " let g:ale_lint_on_enter = 1
  let g:ale_completion_enabled = 1
  let g:ale_set_ballons = 1
  let g:ale_completion_delay = 10
  set omnifunc=ale#completion#OmniFunc
endif

if &runtimepath =~ 'gruvbox'
  if has('nvim')
    colorscheme gruvbox
    if exists('$TMUX')
      hi Normal guibg=NONE
      hi Normal ctermbg=NONE guibg=NONE
    endif
  else
    colorscheme onehalfdark
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
