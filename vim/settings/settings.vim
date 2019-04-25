set nocp

syntax on

set clipboard=unnamed 
set cursorline
set nowrap                            " don't wrap lines
set tabstop=2 shiftwidth=2            " a tab is two spaces (or set this to 4)
set expandtab                         " use spaces, not tabs (optional)
set backspace=indent,eol,start        " backspace through everything in insert mode
set autoindent
set autoread
set copyindent
set number
set showmatch
set smarttab
set title
set nobackup
set noswapfile
set nohlsearch
set mouse=a                           " This is controversial, I know

" allows windows to remain different sizes
set noequalalways

" Split the _right_ way
set splitright
set splitbelow

" Searching
set incsearch                         " incremental searching
set ignorecase                        " ignore case in searching

" set nu rnu                            " set abs number on current line, but relative everywhere else

if !&scrolloff
    set scrolloff=10                    " Show next 10 lines while scrolling.
endif
