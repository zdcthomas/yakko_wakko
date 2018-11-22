set nocp
execute pathogen#infect()

syntax on
colorscheme desert

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
nnoremap ; :

"" Searching
set incsearch                   " incremental searching
set ignorecase                  " ignore case in searching

set runtimepath^=~/.vim/bundle/ctrlp.vim
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=1

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

