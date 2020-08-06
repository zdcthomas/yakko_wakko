if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/z_plugins')
  Plug 'junegunn/vim-plug'         " The current plugin manager
"=================================== Text Editing ================================================
  Plug 'Julian/vim-textobj-variable-segment'          " TO for |this|_part_of_a_var
  Plug 'Yggdroot/indentLine'                          " Display Indentation
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'easymotion/vim-easymotion'
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/vim-easy-align'                      " Easily align text on a specific character
  Plug 'kana/vim-textobj-user'
  Plug 'machakann/vim-highlightedyank'
  Plug 'machakann/vim-sandwich'                       " Love this thing
  Plug 'machakann/vim-swap'                           " Use to swap args in lists/funcs
  Plug 'machakann/vim-textobj-functioncall'
  Plug 'michaeljsmith/vim-indent-object'              " I don't know why this isn't a built in
  Plug 'tpope/vim-commentary'                         " You know, for commenting
  Plug 'simnalamburt/vim-mundo'
  Plug 'tpope/vim-dispatch'

  "=================================== FILE ================================================
  Plug 'ptzz/lf.vim'
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " for the actual bin
  Plug 'junegunn/fzf.vim'
  Plug '~/.fzf'

  " =================================== GIT ================================================
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar

  "=================================== LANGUAGE ============================================
  Plug 'Zaptic/elm-vim'
  Plug 'chrisbra/Colorizer'
  Plug 'elixir-editors/vim-elixir'
  Plug 'rust-lang/rust.vim'
  Plug 'tpope/vim-scriptease'
  Plug 'hashivim/vim-terraform'
  Plug 'leafgarland/typescript-vim'
  Plug 'ianks/vim-tsx'
  Plug 'pangloss/vim-javascript'
  Plug 'keith/swift.vim'
  Plug 'gleam-lang/gleam.vim'
  Plug 'cespare/vim-toml'
  Plug 'chriskempson/base16-vim'

  "=================================== COMPLETION ==========================================
  Plug 'neoclide/coc.nvim', has('nvim') ? {'tag': '*', 'branch': 'release'} : { 'on': [] } " BEEG plugin

  "=================================== STATUS LINE =========================================
  " Plug 'vim-airline/vim-airline'  
  Plug 'itchyny/lightline.vim'

  "=================================== WINDOW ==============================================
  Plug 'moll/vim-bbye'         " Needed for ranger to be nice
  Plug 'segeljakt/vim-silicon' " Taking pictures of code

  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'    
  Plug 'sonph/onehalf', {'rtp': 'vim'}
  " Plug 'dylanaraps/wal' " I should really get this working

  "=================================== UI =================================================
  Plug 'mhinz/vim-startify'    " pretty startup
  Plug 'camspiers/lens.vim'    " slightly expand window when entered
  Plug 'camspiers/animate.vim' " Needed by lens for nicer moving

  "=================================== PERSONAL PLUGINS ===================================
  Plug 'zdcthomas/vish' " vim fish without the slow stuff
  Plug 'zdcthomas/medit'    " Used for editing macros
  Plug 'zdcthomas/vim-abolish'                        " I use this just for camel/snake/pascall case conversion, I should tear that part out
                                                      " (tpopes has MixedCase, i prefer CamelCase, pr is open https://github.com/tpope/vim-abolish/pull/89)
call plug#end()

if &runtimepath =~ 'hardtime'
  let g:hardtime_default_on = 1
  " map f <Plug>Sneak_s
  " map F <Plug>Sneak_S
endif

if &runtimepath =~ 'textobj'
  call textobj#user#plugin('generic', {
  \   'generic': {
  \     'pattern': ["\<\a*<", ">"],
  \     'select-a': 'ag',
  \     'select-i': 'ig'
  \   }
  \ })
endif

" potnetial func regex s/\(\.[A-Za-z]*(\)\@<=[a-zA-Z, ]*)/)/
" still needs {-} for cursor position

if &runtimepath =~ 'auto-pairs'
  augroup AutoPairedUser
    autocmd!
    au FileType rust     let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})
  augroup END
endif

if &runtimepath =~ 'delimit'
  let g:delimitMate_expand_space = 1
  let g:delimitMate_expand_cr = 2
endif

if &runtimepath =~ 'lens'
  let g:lens#height_resize_min = 5
  let g:lens#width_resize_min = 20
endif

if &runtimepath =~ 'multi-cursor'
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
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_previous = '<c-k>'

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  function! s:cocActionsOpenFromSelected(type) abort
    execute 'CocCommand actions.open ' . a:type
  endfunction

  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  nnoremap <silent> gd :call CocAction('jumpDefinition')<Cr>
  nnoremap <silent> <Leader>gdl :call CocAction('jumpDefinition', 'vsplit')<Cr>
  nnoremap <silent> <Leader>gdj :call CocAction('jumpDefinition', 'split')<Cr>
  nnoremap <silent> gh :call CocAction('doHover')<Cr>
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gt <Plug>(coc-type-definition)
  nmap <Leader>rn <Plug>(coc-rename)
  nmap <silent> <Leader>l <Plug>(coc-codelens-action)
  xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
  nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
  nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
  nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
  nmap <Leader>fq <Plug>(coc-fix-current)
  let g:coc_global_extensions = [
        \'coc-json',
        \'coc-vimlsp',
        \'coc-elixir',
        \'coc-tsserver',
        \'coc-rust-analyzer',
        \'coc-prettier',
        \'coc-eslint',
        \'coc-go',
        \'coc-css',
        \'coc-yaml',
        \]
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
  " nnoremap <Leader>q :Bdelete<CR>
endif

" ================================= EASY ALIGN ===========================================
if &runtimepath =~ 'vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" ================================= FZF =================================================
if &runtimepath =~ 'fzf'
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
  " i want a way to search everywhere for the word under the cursor
  " nnoremap <silent> <Leader><Leader>F 
  if has('nvim')
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'rounded' } }
  endif

  " preview for files
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)

  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'alt-j': 'split',
  \ 'ctrl-f': function('s:build_quickfix_list'),
  \ 'alt-l': 'vsplit' }
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

if &runtimepath =~ 'swap'
  omap ia <Plug>(swap-textobject-i)
  xmap ia <Plug>(swap-textobject-i)
  omap aa <Plug>(swap-textobject-a)
  xmap aa <Plug>(swap-textobject-a)
endif

if &runtimepath =~ 'sideways'
  nnoremap <Leader>h :SidewaysLeft<cr>
  nnoremap <Leader>l :SidewaysRight<cr>
  omap aa <Plug>SidewaysArgumentTextobjA
  xmap aa <Plug>SidewaysArgumentTextobjA
  omap ia <Plug>SidewaysArgumentTextobjI
  xmap ia <Plug>SidewaysArgumentTextobjI
endif

if &runtimepath =~ 'gruvbox'
  if has('nvim')
    colorscheme gruvbox
    if exists('$TMUX')
      hi Normal guibg=NONE
      hi Normal ctermbg=NONE guibg=NONE
    endif
  else
    " colorscheme base16-altier-lakeside-light
    " colorscheme onehalfdark
  endif
endif


" This has to be below wherever the colorscheme is set
if &runtimepath =~ 'lightline'
  function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  endfunction

  augroup LightLineStuff
    autocmd!
    autocmd FocusGained * let g:light_line_git_branch = GitBranch()
    
  augroup END

  function! LightlineGitGutter()
    let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
  endfunction

  function! GetGitBranch()
    if exists('g:light_line_git_branch')
      return g:light_line_git_branch
    else
      ''
    endif
  endfunction

  function! LightlineFilename()
    let root = fnamemodify(get(b:, 'git_dir'), ':h')
    let path = expand('%:p')
    if path[:len(root)-1] ==# root
      return path[len(root)+1:]
    endif
    return expand('%')
  endfunction

  function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
  endfunction

  " materia
  " PaperColor
  " Tomorrow_Night_Eighties
  " seoul256
  let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ ['mode', 'paste'], [ 'githunks', 'gitbranch', 'readonly'] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ],  ['filename', 'filetype'] ]
      \   },
      \ 'component_function': {
      \   'githunks': 'LightlineGitGutter',
      \   'filename': 'LightlineFilename',
      \   'readonly': 'LightlineReadonly',
      \   'gitbranch': 'GetGitBranch'
      \   },
      \ 'component': {
      \   'filename': '%<%{LightLineFilename()}',
      \   },
      \ }
end


if &runtimepath =~ 'lf'
  let g:lf_map_keys = 0
  nnoremap <leader>n :Lf<CR>
  let g:lf_replace_netrw = 1
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

if &runtimepath =~ 'sandwich'
  let g:sandwich_no_default_key_mappings = 1
  let g:operator_sandwich_no_default_key_mappings = 1
  let g:textobj_sandwich_no_default_key_mappings = 1

  nmap ys <Plug>(operator-sandwich-add)
  onoremap <SID>line :normal! ^vg_<CR>
  nmap <silent> yss <Plug>(operator-sandwich-add)<SID>line
  onoremap <SID>gul g_
  nmap yS ys<SID>gul

  nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

  xmap S <Plug>(operator-sandwich-add)

  xmap is <Plug>(textobj-sandwich-query-i)
  xmap as <Plug>(textobj-sandwich-query-a)
  omap is <Plug>(textobj-sandwich-query-i)
  omap as <Plug>(textobj-sandwich-query-a)

  xmap iss <Plug>(textobj-sandwich-auto-i)
  xmap ass <Plug>(textobj-sandwich-auto-a)
  omap iss <Plug>(textobj-sandwich-auto-i)
  omap ass <Plug>(textobj-sandwich-auto-a)

  xmap im <Plug>(textobj-sandwich-literal-query-i)
  xmap am <Plug>(textobj-sandwich-literal-query-a)
  omap im <Plug>(textobj-sandwich-literal-query-i)
  omap am <Plug>(textobj-sandwich-literal-query-a)

  runtime autoload/repeat.vim
  if hasmapto('<Plug>(RepeatDot)')
    nmap . <Plug>(operator-sandwich-predot)<Plug>(RepeatDot)
  else
    nmap . <Plug>(operator-sandwich-dot)
  endif

  function! StructInput() abort
    let s:StructLast = input('Struct: ')
    if s:StructLast !=# ''
      let struct = printf('%%%s{', s:StructLast)
    else
      throw 'OperatorSandwichCancel'
    endif
    return [struct, '}']
  endfunction

  function! GenericInput() abort
    let s:GenericLast = input('Generic: ')
    if s:GenericLast !=# ''
      let struct = printf('%s<', s:GenericLast)
    else
      throw 'OperatorSandwichCancel'
    endif
    return [struct, '>']
  endfunction

  let g:sandwich#magicchar#f#patterns = [
	\   {
	\     'header' : '\h*\:*\h*',
	\     'bra'    : '(',
	\     'ket'    : ')',
	\     'footer' : '',
	\   },
	\ ] 

  " Default recipes
  let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
      \   {
      \     'buns'    : ['%{', '}'],
      \     'input'   : ['m'],
      \     'nesting' : 1
      \   },
      \   {
      \     'buns'    : 'StructInput()',
      \     'kind'    : ['add', 'replace', 'delete'],
      \     'action'  : ['add'],
      \     'input'   : ['s'],
      \     'listexpr': 1,
      \     'nesting' : 1
      \   },
      \   {
      \     'buns'    : 'GenericInput()',
      \     'kind'    : ['add', 'replace'],
      \     'action'  : ['add'],
      \     'input'   : ['g'],
      \     'listexpr': 1,
      \     'nesting' : 1
      \   },
      \   {
      \     'buns'    : ['\w\+<', '>'],
      \     'input'   : ['g'],
      \     'nesting' : 1,
      \     'regex'   : 1,
      \   },
      \   {
      \     'buns'    : ['#{', '}'],
      \     'input'   : ['n'],
      \     'nesting' : 1
      \   },
      \ ]
  " n = iNterpolate
  " m = Map
  " g = Generic
endif

if &runtimepath =~ 'mundo'
  function LensToggle() abort
    if g:lens#disabled
      let g:lens#disabled=0
    else
      let g:lens#disabled=1
    endif
  endfunction

  function DoMundo() abort
    call LensToggle()
    MundoToggle
  endfunction

  nnoremap <Leader>u :call DoMundo()<Cr>
  " augroup mund
  "   autocmd!
  "   autocmd BufEnter __Mundo__ :call LensToggle()
    
  " augroup END
endif
