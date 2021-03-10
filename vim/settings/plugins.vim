if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/z_plugins')
  Plug 'junegunn/vim-plug'         " The current plugin manager
"=================================== Text Editing ================================================
  Plug 'AndrewRadev/sideways.vim'                     " just for inserting new elements into the list
  Plug 'dpretet/vim-leader-mapper'
  Plug 'junegunn/vim-easy-align'                      " Easily align text on a specific character
  Plug 'machakann/vim-highlightedyank'
  Plug 'machakann/vim-sandwich'                       " Love this thing
  Plug 'machakann/vim-swap'                           " Use to swap args in lists/funcs, has a 'mode' for lists
  Plug 'simnalamburt/vim-mundo'
  Plug 'tpope/vim-commentary'                         " You know, for commenting
  Plug 'tpope/vim-dispatch', {'on': 'Dispatch'}
  Plug 'vimwiki/vimwiki'

  "=================================== TEXT OBJECTS ==========================================
  Plug 'kana/vim-textobj-user'
  Plug 'glts/vim-textobj-comment'
  Plug 'machakann/vim-textobj-functioncall'
  Plug 'Julian/vim-textobj-variable-segment'          " TO for |this|_part_of_a_var
  Plug 'michaeljsmith/vim-indent-object'              " I don't know why this isn't a built in

  "=================================== AUTO PAIRING POSSIBILITIES ===============================
  " I hate all of them but they're pretty convenient
  Plug 'jiangmiao/auto-pairs'

  "=================================== FILE ================================================
  Plug 'ptzz/lf.vim', {'on': 'Lf'}
  Plug 'junegunn/fzf.vim'
  Plug '~/.fzf'

  " =================================== GIT ================================================
  Plug 'airblade/vim-gitgutter'    " Show changes to repo in sidebar

  "=================================== LANGUAGE ============================================
  Plug 'Zaptic/elm-vim', {'for': 'elm'}
  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'chrisbra/Colorizer'
  Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
  Plug 'gleam-lang/gleam.vim', {'for': 'gleam'}
  Plug 'hashivim/vim-terraform'
  Plug 'ianks/vim-tsx'
  Plug 'keith/swift.vim', {'for': 'swift'}
  Plug 'leafgarland/typescript-vim'
  Plug 'pangloss/vim-javascript'
  Plug 'rust-lang/rust.vim', {'for': 'rust'}
  Plug 'nicwest/vim-camelsnek'
  Plug 'idris-hackers/idris-vim'
  Plug 'jvirtanen/vim-hcl'

  "=================================== COMPLETION ==========================================
  " Plug 'neoclide/coc.nvim', has('nvim') ? {'tag': '*', 'branch': 'release'} : { 'on': [] } " BEEG plugin
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

  Plug 'antoinemadec/coc-fzf'

  "=================================== STATUS LINE =========================================
  Plug 'itchyny/lightline.vim'

  "=================================== WINDOW ==============================================
  Plug 'moll/vim-bbye'                            " Needed for ranger to be nice
  Plug 'segeljakt/vim-silicon', {'on': 'Silicon'} " Taking pictures of code

  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'    
  " Plug 'lifepillar/vim-gruvbox8'
  Plug 'sonph/onehalf', {'rtp': 'vim'}
  Plug 'chriskempson/base16-vim'
  Plug 'joshdick/onedark.vim'

  "=================================== UI =================================================
  Plug 'mhinz/vim-startify'    " pretty startup
  Plug 'camspiers/lens.vim'    " slightly expand window when entered
  " Plug 'camspiers/animate.vim' " Needed by lens for nicer moving

  "=================================== PERSONAL PLUGINS ===================================
  Plug 'zdcthomas/vish', {'for': 'fish'} " vim fish without the slow stuff
  Plug 'zdcthomas/medit'                 " Used for editing macros
  " Plug 'zdcthomas/vim-abolish'           " I use this just for camel/snake/pascall case conversion, I should tear that part out
                                         " (tpopes has MixedCase, i prefer CamelCase, pr is open https://github.com/tpope/vim-abolish/pull/89)
call plug#end()

if &runtimepath =~ 'textobj'
  call textobj#user#plugin('generic', {
  \   'generic': {
  \     'pattern': ["\<\a*<", ">"],
  \     'select-a': 'ag',
  \     'select-i': 'ig'
  \   }
  \ })
endif

if &runtimepath =~ 'sneak'
  map f <Plug>Sneak_f
  map F <Plug>Sneak_F
  map t <Plug>Sneak_t
  map T <Plug>Sneak_T
  let g:sneak#s_next = 1
endif

if &runtimepath =~ 'snek'
  let g:camelsnek_alternative_camel_commands = 1
  nnoremap crs :Snek<CR>
  vnoremap crs :Snek<CR>
  nnoremap crp :Pascal<CR>
  vnoremap crp :Pascal<CR>
  nnoremap crc :Camel<CR>
  vnoremap crc :Camel<CR>
  nnoremap crk :Kebab<CR>
  vnoremap crk :Kebab<CR>
endif

" potnetial func regex s/\(\.[A-Za-z]*(\)\@<=[a-zA-Z, ]*)/)/
" still needs {-} for cursor position

if &runtimepath =~ 'auto-pairs'
  augroup AutoPairedUser
    autocmd!
    au FileType rust let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})
  augroup END
endif

if &runtimepath =~ 'lens'
  let g:lens#height_resize_min = 5
  let g:lens#width_resize_min = 20
endif

" =================================  COC  ===========================================
if &runtimepath =~ 'coc'
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  " if exists('*complete_info')
  "   inoremap <expr> <cr> complete_info()["selected"] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
  " else
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	" 			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  " endif
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

  augroup Coc
    autocmd!
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  augroup END

  nnoremap <silent> gd :call CocAction('jumpDefinition')<Cr>
  nnoremap <silent> <Leader>gdl :call CocAction('jumpDefinition', 'vsplit')<Cr>
  nnoremap <silent> <Leader>gdj :call CocAction('jumpDefinition', 'split')<Cr>
  nnoremap <silent> gh :call CocAction('doHover')<Cr>
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gt <Plug>(coc-type-definition)
  nmap <Leader>rn <Plug>(coc-rename)
  nmap <silent> <Leader>l <Plug>(coc-codelens-action)
  nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
  nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <Leader>fq <Plug>(coc-fix-current)
  let g:coc_global_extensions = [
        \'coc-css',
        \'coc-html',
        \'coc-elixir',
        \'coc-eslint',
        \'coc-go',
        \'coc-json',
        \'coc-actions',
        \'coc-prettier',
        \'coc-rust-analyzer',
        \'coc-tsserver',
        \'coc-yaml',
        \]


  " Remap for do codeAction of selected region
  function! s:cocActionsOpenFromSelected(type) abort
    execute 'CocCommand actions.open ' . a:type
  endfunction

  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  autocmd CursorHold * silent call CocActionAsync('highlight')

  if &runtimepath=~'coc-fzf'
    nnoremap <silent> <leader>ea :<C-u>CocFzfList diagnostics<CR>
    if &runtimepath=~'leader-mapper'
      let g:leaderMenu = {'name':  "coc",
               \'c': [":CocFzfList commands",                  "Commands"],
               \'e': [":CocFzfList extensions",                "Extensions"],
               \'d': [":CocFzfList diagnostics --current-buf", "Diagnostics, current buffer"],
               \'D': [":CocFzfList diagnostics",               "All diagnostics"],
               \'l': [":CocFzfList location",                  "Location"],
               \'o': [":CocFzfList outline",                   "Outline"],
               \'L': [":CocLog",                               "Logs"],
               \'I': [":CocInfo",                              "Info"],
               \'C': [":CocConfig",                           "Open coc config"],
               \'u': [":CocUpdate",                           "Update Coc extensions"],
               \}
      
      nnoremap <silent> <leader>coc :LeaderMapper "coc"<CR>
    endif
  endif

  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

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
  let window = {}
  let window.width = 0.9
  let window.height = 0.6
  if &runtimepath =~ 'gruvbox'
    let window.highlight = 'GruvboxAqua'
  endif
  let window.border = 'rounded'
  let g:fzf_layout = { 'window': window }

  let g:fzf_buffers_jump = 1

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--layout=reverse']}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -bang -nargs=* RgWithWord
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.expand("<cword>"), 1,
    \   fzf#vim#with_preview({'options': ['--layout=reverse']}), <bang>0)

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

  nnoremap <silent> <Leader>p :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  " nnoremap <silent> <Leader>G :Lines<CR>
  nnoremap <silent> <Leader>gf :GFiles?<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
  " TODO: here we should have leader F in visual mode just search for the visual selection
  " visual selection expantions are hard
  nnoremap <silent> <Leader>F :RG<CR>
  nnoremap <silent> <Leader>* :RgWithWord<CR>
  nnoremap <silent> <Leader>C :Colors<CR>
  nnoremap <silent> <Leader>: :Commands<CR>
  nnoremap <silent> <Leader><Leader><Leader> :Maps<CR>

  " preview for files
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""', 'options': ['--layout=reverse']}), <bang>0)

  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
  \ 'alt-j': 'split',
  \ 'alt-l': 'vsplit',
  \ 'ctrl-f': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split' }

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
  omap ih <Plug>(GitGutterTextObjectInnerPending)
  omap ah <Plug>(GitGutterTextObjectOuterPending)
  xmap ih <Plug>(GitGutterTextObjectInnerVisual)
  xmap ah <Plug>(GitGutterTextObjectOuterVisual)
endif

if &runtimepath =~ 'sideways'
  nmap <leader>si <Plug>SidewaysArgumentInsertBefore
  nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
  nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
  nmap <leader>sA <Plug>SidewaysArgumentAppendLast
endif

if &runtimepath =~ 'swap'
  omap ia <Plug>(swap-textobject-i)
  xmap ia <Plug>(swap-textobject-i)
  omap aa <Plug>(swap-textobject-a)
  xmap aa <Plug>(swap-textobject-a)
endif

if &runtimepath =~ 'gruvbox'
  if has('nvim')
    let g:gruvbox_vert_split='faded_aqua'
    colorscheme gruvbox
    " if exists('$TMUX')
    "   hi Normal guibg=NONE
    "   hi Normal ctermbg=NONE guibg=NONE
    " endif
  endif
endif


" This has to be below wherever the colorscheme is set
if &runtimepath =~ 'lightline'
  call SourceFile("~/.vim/settings/plugins/lightline.vim")
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
  call SourceFile("~/.vim/settings/plugins/sandwich_settings.vim")
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

if &runtimepath =~ 'vimwiki'
  let primary = {}
  let primary.path = '~/irulan/wiki'
  let primary.syntax = 'markdown'
  let primary.ext = 'md'

  let g:vimwiki_list = [primary]
  let g:vimwiki_conceallevel=0
  let g:vimwiki_filetypes = ['markdown']

  " This allows tab complete to still work
  let g:vimwiki_key_mappings =
    \ {
    \ 'table_mappings': 0,
    \ }

endif
