set nocp

syntax on

" a buffer becomes hidden when it is abandoned.
set hidden
set shell=sh
" uses system clipboard for copy pasting
set clipboard=unnamed

" Highlight the current line (CAN ALSO SLOW THINGS DOWN)
set cursorline

set concealcursor=nc

" don't conceal characters
set conceallevel=0

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

" don't automatically save
set noautowrite
set noautowriteall

" Copy indent from current line when starting a new line (typing <CR> in Insert mode or when using the "o" or "O" command).
set autoindent

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
set autoread

" Copy the structure of the existing lines indent when autoindenting a new line.
set copyindent

" When this option is set, the screen will not be redrawn while executing macros
set lazyredraw

" Show the matching pair (bracket, paren, brace etc.)
set showmatch

" When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
set smarttab

" When on, the title of the window will be set to the value of 'titlestring' (if it is not empty)
set title

" Enables 24-bit RGB color in the |TUI|.
set termguicolors

" Stops vim from saving weird swp files, I'm probably just bad at them though tbf
set nobackup
set noswapfile

" Stop the highlighting for the 'hlsearch' option
set nohlsearch

" This is controversial, I know (it's just mouse support)
set mouse=a                           

" I don't use them, and they've been dangerous before
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
" set nowrapscan
