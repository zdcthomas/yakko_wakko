set nocp

syntax on

set hidden
set shell=sh
" uses system clipboard for copy pasting
set clipboard=unnamed

" Highlight the current line (CAN ALSO SLOW THINGS DOWN)
set cursorline

set concealcursor=nc

" don't wrap lines
set nowrap                            

" a tab is two spaces (or set this to 4)
set tabstop=2 shiftwidth=2            

" use spaces, not tabs (optional)
set expandtab                         

" backspace through everything in insert mode
set backspace=indent,eol,start        

" turns on line numbers
set number

set autoindent
set autoread
set autowriteall
set copyindent
set lazyredraw

" Show the matching pair (bracket, paren, brace etc.)
set showmatch

set smarttab
set title

set termguicolors

" Stops vim from saving weird swp files, I'm probably just bad at them though tbf
set nobackup
set noswapfile

set nohlsearch

" This is controversial, I know (it's just mouse support)
set mouse=a                           

set nomodeline

" Split the _right_ way
set splitright
set splitbelow

" incremental searching
set incsearch                         

" ignore case in searching
set ignorecase                        

" if !&scrolloff
"     " Show next 10 lines while scrolling.
set scrolloff=10
" endif

set fillchars=vert:%

set noequalalways

" I'm tryring this out mostly for end conditions in macros, but also, like,
" I'm a big kid and can search backward on my own.
set nowrapscan
