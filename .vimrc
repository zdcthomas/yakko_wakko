set nocp
execute pathogen#infect()

syntax on
colorscheme desert

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

set ai
set si
set incsearch
set ruler
set so=7
set autoread
set clipboard=unnamed 
set nowrap                                                   " don't wrap lines
set tabstop=2 shiftwidth=2                                   " a tab is two spaces (or set this to 4)
set expandtab                                                " use spaces, not tabs (optional)
set backspace=indent,eol,start                               " backspace through everything in insert mode
set autoindent
set copyindent
set number
set showmatch
set smarttab
set title
set nobackup
set noswapfile
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ \ Line:\ %l\ \ Column:\ %c\ \ \ %=\ CWD:\ %r%{getcwd()}%h\ \ 


nnoremap ; :

"" Searching
set incsearch                   " incremental searching
set ignorecase                  " ignore case in searching

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
set runtimepath^=~/.vim/bundle/ctrlp.vim
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=1

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

