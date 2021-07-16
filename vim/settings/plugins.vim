if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/z_plugins')
  Plug 'junegunn/vim-plug'                   " The current plugin manager
  "=================================== Text Editing =========================================
  " Plug '~/playground/vim-swap'             " Use to swap args in lists/funcs, has a 'mode' for lists
  Plug 'AndrewRadev/sideways.vim'            " Just for inserting new elements into the list
  Plug 'junegunn/goyo.vim'                   " Focused text editing
  Plug 'junegunn/limelight.vim'              " Highlights the current paragraph
  Plug 'junegunn/vim-easy-align'             " Easily align text on a specific character
  Plug 'machakann/vim-highlightedyank'       " Highlights yanked section
  Plug 'machakann/vim-sandwich'              " Love this thing
  Plug 'machakann/vim-swap'                  " Use to swap args in lists/funcs, has a 'mode' for lists
  Plug 'nicwest/vim-camelsnek'               " Convert text between different casings
  Plug 'tpope/vim-commentary'                " You know, for commenting
  Plug 'vim-scripts/DrawIt'                  " Box drawing
  Plug 'vimwiki/vimwiki'                     " Wiki management and bindings
  Plug '~/playground/vim-leader-mapper'      " Really nice menu plugin
  Plug 'mbbill/undotree'

  "=================================== TEXT OBJECTS =======================================
  Plug 'kana/vim-textobj-user'               " User defined text objects... what it says on the tin
  Plug 'Julian/vim-textobj-variable-segment' " Text Object for |this|_part_of_a_var
  Plug 'michaeljsmith/vim-indent-object'     " I don't know why this isn't a built in

  "=================================== AUTO PAIRING POSSIBILITIES =========================
  Plug 'jiangmiao/auto-pairs'                " I hate all of them but they're pretty convenient

  "=================================== FILE ===============================================
  Plug 'junegunn/fzf.vim'                    " Best fuzzy finder this side of the mississippi
  Plug '~/.fzf'                              " The actual binary
  Plug 'justinmk/vim-dirvish'                " File explorer
  Plug 'kristijanhusak/vim-dirvish-git'      " Git signs in dirvish
  Plug 'roginfarrer/vim-dirvish-dovish'      " Basic actions in dirvish

  " =================================== GIT ===============================================
  Plug 'rhysd/git-messenger.vim'             " Brings up helpful window to view commit message for line
  Plug 'airblade/vim-gitgutter'              " Show changes to repo in sidebar

  "=================================== LANGUAGE ===========================================
  Plug 'Zaptic/elm-vim',                     {'for': 'elm'}
  Plug 'cespare/vim-toml',                   {'for': 'toml'}
  Plug 'elixir-editors/vim-elixir',          {'for': 'elixir'}
  Plug 'gleam-lang/gleam.vim',               {'for': 'gleam'}
  Plug 'hashivim/vim-terraform',             {'for': 'terraform'}
  Plug 'ianks/vim-tsx',                      {'for': 'typescript'}
  Plug 'idris-hackers/idris-vim',            {'for': 'idris'}
  Plug 'jparise/vim-graphql',                {'for': 'graphql'}
  Plug 'keith/swift.vim',                    {'for': 'swift'}
  Plug 'leafgarland/typescript-vim',         {'for': 'typescript'}
  Plug 'pangloss/vim-javascript',            {'for': 'javascript'}
  Plug 'rust-lang/rust.vim',                 {'for': 'rust'}

  "=================================== COMPLETION =========================================
  Plug 'neoclide/coc.nvim',                  {'do':  'yarn install --frozen-lockfile'}
  Plug '~/playground/coc-fzf'

  "=================================== STATUS LINE ========================================
  Plug 'itchyny/lightline.vim'

  "=================================== WINDOW =============================================
  Plug 'segeljakt/vim-silicon',              {'on':  'Silicon'} " Taking pictures of code

  "=================================== HTML ===============================================
  Plug 'mattn/emmet-vim'

  "=================================== COLOR SCHEMES ======================================
  Plug 'gruvbox-community/gruvbox'
  Plug 'ayu-theme/ayu-vim'
  Plug 'yuttie/hydrangea-vim'
  Plug 'cocopon/iceberg.vim'
  Plug 'arcticicestudio/nord-vim'

  "=================================== UI =================================================
  Plug 'mhinz/vim-startify'                  " pretty startup

  "=================================== PERSONAL PLUGINS ===================================
  Plug 'zdcthomas/vish',                     {'for': 'fish'}    " vim fish without the slow stuff
  Plug 'zdcthomas/medit'                     " Used for editing macros

call plug#end()

if &runtimepath =~ 'leader-mapper'
  let g:leaderMenu   = {'name':                 "primary"}
  let g:leaderMenu.s = [':Svrc',                "Re-source Vim config"]
  let g:leaderMenu.e = [":!dmux ~/yakko_wakko", "Edit dotfiles"]

  nnoremap <silent> <leader><leader> :LeaderMapper "primary"<CR>
  if &runtimepath =~ 'plug'

      let PlugLeaderMenu = {'name':    "plug",
               \'u': [":PlugUpdate",   "Update all plugins"],
               \'i': [":PlugInstall",  "Install all uninstalled plugins"],
               \'c': [":PlugClean",    "Clean out unused plugins"],
               \'s': [":PlugStatus",   "Status"],
               \'S': [":PlugSnapshot", "Generate snapshot of current plugin config"],
               \}
      let g:leaderMenu.p = [PlugLeaderMenu, "Plug"]

  endif
endif

if &runtimepath =~ 'dirvish'
  let g:loaded_netrwPlugin = 1
  command! -nargs=? -complete=dir Explore Dirvish <args>
  command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
  command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
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
    au FileType vim let b:AutoPairs  = AutoPairsDefine({}, ['"'])
  augroup END
endif

" =================================  COC  ===========================================
if &runtimepath =~ 'coc'
  let g:coc_snippet_next = '<c-n>'
  let g:coc_snippet_previous = '<c-p>'

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
  nmap <Leader>cf <Plug>(coc-fix-current)
  
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
    nnoremap <silent> <leader>cd :<C-u>CocFzfList diagnostics<CR>
    nnoremap <silent> <leader>co :<C-u>CocFzfList outline<CR>
    nnoremap <silent> <leader>cs :<C-u>CocFzfList symbols<CR>

    if &runtimepath=~'leader-mapper'
      let CocLeaderMenu = {'name':  "coc",
               \'C': [":CocConfig",                       "Open coc config"],
               \'F': [":CocFzfList",                      "all fzf stuffs"],
               \'I': [":CocInfo",                         "Info"],
               \'c': [":CocFzfList commands",             "Commands"],
               \'d': [":CocFzfList diagnostics",          "Diagnostics"],
               \'e': [":CocFzfList extensions",           "Extensions"],
               \'f': [":CocFix",                          "Fix"],
               \'l': [":CocFzfList location",             "Location"],
               \'o': [" :call coc_fzf#outline#fzf_run()", "Outline"],
               \'u': [":CocUpdate",                       "Update Coc extensions"],
               \}

      let g:leaderMenu.c = [CocLeaderMenu,                  "Completion commands with Coc"]
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

  let window = {'width': 0.9, 'height': 0.6, 'highlight': 'DiffChange', 'border': 'rounded'}
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
  " TODO: here we should have leader F in visual mode just search for the visual selection
  " visual selection expantions are hard
  nnoremap <silent> <Leader>F :RG<CR>
  nnoremap <silent> <Leader>* :RgWithWord<CR>


  if &runtimepath =~ 'leader-mapper'

        let FzfLeaderMenu = {'name': "Fzf Search",
                 \':': [":Commands", "Commands"],
                 \'C': [":Colors",   "Color scheme"],
                 \'c': [":Commits",  "Commits"],
                 \'g': [":GFiles?",  "Git files"],
                 \'m': [":Maps",     "Mappings"]
                 \}

    let g:leaderMenu.f =[FzfLeaderMenu, "FZF selections"]
  endif
  " preview for files
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(fzf#wrap({'source': 'ag --hidden --ignore .git -g ""', 'options': ['--layout=reverse']})), <bang>0)

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

  if &runtimepath =~ 'vimwiki'
    let s:create_key = 'ctrl-x'
    function NoteHandler(lines) abort
      echom join(a:lines, '|')
      let wiki_dir = '~/irulan/wiki/' 
      if a:lines == [] || a:lines == ['','','']
          return
      endif

      let query = a:lines[0]
      let keypress = a:lines[1]
      let keymap = extend(g:fzf_action, {s:create_key : 'vertical split'})
      let note_window = 'vertical split'
      let cmd = get(keymap, keypress, 'edit')
      if len(a:lines) == 2 && (a:lines[-1] == s:create_key || a:lines[-1] == 'enter')
        let candidate = fnameescape(wiki_dir . query . '.md')
      elseif len(a:lines) == 3
        let candidate = a:lines[2]
      else
        return
      endif
      
      execute cmd . ' ' . candidate
      augroup WikiNewBuf
        autocmd!
        autocmd BufWritePre <buffer> call mkdir(expand("<afile>:p:h"), "p")
      augroup END
    endfunction

    function TryIt() abort
      call fzf#run(fzf#wrap({ 'sink*': function('NoteHandler'), 'dir': '~/irulan/wiki',
            \ 'options': '--expect=enter,ctrl-x,' . join(keys(g:fzf_action), ',') . ' --print-query --exact'}))
    endfunction

    command! -nargs=* -bang Note call TryIt()
    nnoremap <leader>n :Note<Cr>
  endif

endif

" =================================  GITGUTTER  ===========================================
if &runtimepath =~ 'vim-gitgutter'
  set updatetime=100
  let g:gitgutter_map_keys = 0
  command! Gqf GitGutterQuickFix | copen
  nnoremap <Leader>gc :Gqf<CR>
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


if &runtimepath =~ 'markdown'
  let vim_markdown_preview_github=1
endif

if &runtimepath =~ 'sandwich'
  call SourceFile("~/.vim/settings/plugins/sandwich_settings.vim")
endif

if &runtimepath =~ 'vimwiki'
  let primary = {
        \'path':  '~/irulan/wiki',
        \'syntax':  'markdown',
        \'ext': 'md',
        \'custom_wiki2html': 'vimwiki_markdown',
        \'html_filename_parameterization': 1,
        \'template_default': 'default',
        \'template_ext': '.tpl',
        \'template_path': '~/irulan/templates/',
        \}

  let g:vimwiki_list = [primary]
  let g:vimwiki_conceallevel=0
  let g:vimwiki_markdown_link_ext = 1
  let g:vimwiki_filetypes = ['markdown']
  let g:vimwiki_global_ext = 0

  " This allows tab complete to still work
  " As well as - for dirvish
  let g:vimwiki_key_mappings =
    \ {
    \ 'headers': 0,
    \ 'table_mappings': 0, 
    \ 'vimwiki_<C-Space>': 0,
    \ }

  let g:vimwiki_valid_html_tags = 'b,i,s,u,sub,sup,kbd,br,hr, pre, script'
  nmap <Leader>c <Plug>VimwikiToggleListItem

  if &runtimepath =~ 'leader-mapper'
        let VimwikiLeaderMenu = {'name':         "vimwiki",
                 \'s': [":VimwikiUISelect",      "open Wiki selection ui"],
                 \'i': [":VimwikiIndex 1",       "Irulan"],
                 \'e': [":VimwikiMakeDiaryNote", "Ephemeral"],
                 \'d': [":!dmux ~/irulan",       "edit"],
                 \'t': [":VimwikiTOC",           "Table of content"]
                 \}

    let g:leaderMenu.w =[VimwikiLeaderMenu, "vimwiki"]
  endif
endif

if &runtimepath =~ 'goyo'
  let g:goyo_width = "65%"
  function! s:goyo_enter()
    if (&filetype =~ 'markdown')
      Limelight
      if executable('tmux') && strlen($TMUX)
        silent !tmux set status off
        silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
      endif
    else
      " set number
    endif

  endfunction

  function! s:goyo_leave()
    if (&filetype =~ 'markdown')
      Limelight!
      if executable('tmux') && strlen($TMUX)
        silent !tmux set status on
        silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
      endif
    endif
  endfunction

  augroup GOYO
    autocmd!
    autocmd User GoyoEnter nested call <SID>goyo_enter()
    autocmd User GoyoLeave nested call <SID>goyo_leave()
  augroup END

  if &runtimepath =~ 'leader-mapper'
    let g:leaderMenu.g =[":Goyo", "Goyo"]                                                        
  endif                                                                                          

end                                                                                              

if &runtimepath =~ 'draw'
  if &runtimepath =~ 'leader-mapper'
    let DrawingLeaderMenu = {'name': "Draw mode",
             \'d': [":DrawIt",       "Enter drawing mode"],
             \'s': [":DrawIt!",      "Stop drawing mode"],
             \'t': [":VimwikiTOC",   "Table of content"]
             \}

    let g:leaderMenu.d =[DrawingLeaderMenu, "Draw mode"]
  endif
endif
