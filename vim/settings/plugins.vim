if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/z_plugins')
  Plug 'junegunn/vim-plug'                   " The current plugin manager
"=================================== Text Editing ================================================
  Plug 'AndrewRadev/sideways.vim'            " just for inserting new elements into the list
  Plug 'dpretet/vim-leader-mapper'
  Plug 'junegunn/vim-easy-align'             " Easily align text on a specific character
  Plug 'machakann/vim-highlightedyank'
  Plug 'machakann/vim-sandwich'              " Love this thing
  Plug 'machakann/vim-swap'                  " Use to swap args in lists/funcs, has a 'mode' for lists
  Plug 'simnalamburt/vim-mundo'
  Plug 'tpope/vim-commentary'                " You know, for commenting
  Plug 'vimwiki/vimwiki'
  Plug 'rhysd/git-messenger.vim'             " Brings up helpful window to view commit message for line
  Plug 'nicwest/vim-camelsnek'

  "=================================== TEXT OBJECTS ==========================================
  Plug 'kana/vim-textobj-user'
  Plug 'glts/vim-textobj-comment'
  Plug 'Julian/vim-textobj-variable-segment' " Text Object for |this|_part_of_a_var
  Plug 'michaeljsmith/vim-indent-object'     " I don't know why this isn't a built in

  "=================================== AUTO PAIRING POSSIBILITIES ===============================
  " I hate all of them but they're pretty convenient
  Plug 'jiangmiao/auto-pairs'

  "=================================== FILE ================================================
  Plug 'junegunn/fzf.vim'
  Plug '~/.fzf'
  Plug 'justinmk/vim-dirvish'
  Plug 'kristijanhusak/vim-dirvish-git'
  Plug 'roginfarrer/vim-dirvish-dovish'

  " =================================== GIT ================================================
  Plug 'airblade/vim-gitgutter'              " Show changes to repo in sidebar

  "=================================== LANGUAGE ============================================
  Plug 'Zaptic/elm-vim',                     {'for': 'elm'}
  Plug 'cespare/vim-toml',                   {'for': 'toml'}
  Plug 'elixir-editors/vim-elixir',          {'for': 'elixir'}
  Plug 'gleam-lang/gleam.vim',               {'for': 'gleam'}
  Plug 'hashivim/vim-terraform',             {'for': 'terraform'}
  Plug 'ianks/vim-tsx',                      {'for': 'typescript'}
  Plug 'idris-hackers/idris-vim',            {'for': 'idris'}
  Plug 'keith/swift.vim',                    {'for': 'swift'}
  Plug 'leafgarland/typescript-vim',         {'for': 'typescript'}
  Plug 'pangloss/vim-javascript',            {'for': 'javascript'}
  Plug 'rust-lang/rust.vim',                 {'for': 'rust'}

  "=================================== COMPLETION ==========================================
  Plug 'neoclide/coc.nvim',                  {'do':  'yarn install --frozen-lockfile'}
  Plug 'antoinemadec/coc-fzf'

  "=================================== STATUS LINE =========================================
  Plug 'itchyny/lightline.vim'

  "=================================== WINDOW ==============================================
  Plug 'segeljakt/vim-silicon',              {'on':  'Silicon'} " Taking pictures of code

  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'

  "=================================== UI =================================================
  Plug 'mhinz/vim-startify'                  " pretty startup

  "=================================== PERSONAL PLUGINS ===================================
  Plug 'zdcthomas/vish',                     {'for': 'fish'}    " vim fish without the slow stuff
  Plug 'zdcthomas/medit'                     " Used for editing macros

call plug#end()

if &runtimepath =~ 'leader-mapper'
  let g:leaderMenu = {'name':  "primary"}
  let g:leaderMenu.s = [':Svrc',                "Re-source Vim config"]
  let g:leaderMenu.e = [":!dmux ~/yakko_wakko", "Edit dotfiles"]

  nnoremap <silent> <leader><leader> :LeaderMapper "primary"<CR>
  if &runtimepath =~ 'plug'

      let PlugLeaderMenu = {'name':  "plug",
               \'u': [":PlugUpdate",        "Update"],
               \'i': [":PlugInstall",       "Install"],
               \'c': [":PlugClean",         "Clean"],
               \}
      let g:leaderMenu.p = [PlugLeaderMenu, "Plug"]

  endif
endif

if &runtimepath =~ 'git-messenger'
endif

if &runtimepath =~ 'dirvish'
  let g:loaded_netrwPlugin = 1
  command! -nargs=? -complete=dir Explore Dirvish <args>
  command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
  command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
  nnoremap <leader>n :Explore<cr>
  let g:dirvish_mode=':sort | sort ,^.*[^/]$, r'
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

if &runtimepath =~ 'auto-pairs'
  augroup AutoPairedUser
    autocmd!
    au FileType rust let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})
    au FileType vim let b:AutoPairs  = AutoPairsDefine(['"'])
  augroup END
endif

if &runtimepath =~ 'lens'
  let g:lens#height_resize_min = 5
  let g:lens#width_resize_min = 20
endif

" =================================  COC  ===========================================
if &runtimepath =~ 'coc'
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
  nnoremap <silent> gh :call CocActionAsync('doHover')<Cr>
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gt <Plug>(coc-type-definition)
  nmap <Leader>rn <Plug>(coc-rename)
  nmap <silent> <Leader>l <Plug>(coc-codelens-action)
  nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
  nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <Leader>fq <Plug>(coc-fix-current)
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  let g:coc_global_extensions = [
        \'coc-css',
        \'coc-elixir',
        \'coc-go',
        \'coc-json',
        \'coc-rust-analyzer',
        \'coc-tsserver',
        \'coc-yaml',
        \]
        " \'coc-prettier',
        " \'coc-html',
        " \'coc-eslint',


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
      let CocLeaderMenu = {'name':  "coc",
               \'co': [":CocFzfList commands",                  "Commands"],
               \'e': [":CocFzfList extensions",                "Extensions"],
               \'d': [":CocFzfList diagnostics --current-buf", "Diagnostics, current buffer"],
               \'D': [":CocFzfList diagnostics",               "All diagnostics"],
               \'l': [":CocFzfList location",                  "Location"],
               \'o': [":CocFzfList outline",                   "Outline"],
               \'L': [":CocLog",                               "Logs"],
               \'cl': [":CocAction('codeLensAction')",          "CodeLens Action"],
               \'I': [":CocInfo",                              "Info"],
               \'C': [":CocConfig",                            "Open coc config"],
               \'u': [":CocUpdate",                            "Update Coc extensions"],
               \}

      let g:leaderMenu.c = [CocLeaderMenu,                  "Coc menu"]
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


if &runtimepath =~ 'elm-vim'
  let g:elm_setup_keybindings = 0
endif

if &runtimepath =~ 'startify'
  let g:startify_lists = [{ 'type': 'dir',       'header': ['   MRU '. getcwd()] }]

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

    if &runtimepath=~'leader-mapper'
      let g:leaderMenu.S = [":Startify",                  "Startify"]
    endif
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
  nnoremap <silent> <Leader>gf :GFiles?<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
  " TODO: here we should have leader F in visual mode just search for the visual selection
  " visual selection expantions are hard
  nnoremap <silent> <Leader>F :RG<CR>
  nnoremap <silent> <Leader>* :RgWithWord<CR>
  nnoremap <silent> <Leader>C :Colors<CR>
  nnoremap <silent> <Leader>: :Commands<CR>
  nnoremap <silent> <Leader>m :Maps<CR>

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

  if &runtimepath =~ 'leader-mapper'
    
        let VimwikiLeaderMenu = {'name':  "vimwiki",
                 \'w': [":VimwikiUISelect", "open Wiki selection ui"],
                 \'t': [":VimwikiTOC",      "Table of content"]
                 \}

    let g:leaderMenu.w =[VimwikiLeaderMenu, "vimwiki"]
  endif
endif

