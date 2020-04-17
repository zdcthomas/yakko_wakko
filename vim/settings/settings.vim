set nocp
syntax on
if has('clipboard')
  set clipboard=unnamed        " uses system clipboard for copy pasting
endif
set shell=sh                   " Faster than whatever the default shell will be
set hidden                     " a buffer becomes hidden when it is abandoned.
set cursorline                 " Highlight the current line (CAN ALSO SLOW THINGS DOWN)
set concealcursor=nc           " sets a conceal level
set conceallevel=0             " don't conceal characters
set nowrap                     " don't wrap lines
set tabstop=2 shiftwidth=2     " a tab is two spaces (or set this to 4)
set expandtab                  " use spaces, not tabs (optional)
set backspace=indent,eol,start " backspace through everything in insert mode
set number                     " turns on line numbers
set noautowrite                " don't automatically save
set noautowriteall             " don't automatically save
set autoindent                 " Copy indent from current line when starting a new line (typing <CR> in Insert mode or when using the "o" or "O" command).
set autoread                   " When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set copyindent                 " Copy the structure of the existing lines indent when autoindenting a new line.
set lazyredraw                 " When this option is set, the screen will not be redrawn while executing macros
set showmatch                  " Show the matching pair (bracket, paren, brace etc.)
set smarttab                   " When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
set title                      " When on, the title of the window will be set to the value of 'titlestring' (if it is not empty)
set termguicolors              " Enables 24-bit RGB color in the |TUI|.
set nobackup                   " Stops vim from saving weird swp files, I'm probably just bad at them though tbf
set noswapfile                 " No annoying swap files either
set nohlsearch                 " Stop the highlighting for the 'hlsearch' option
set mouse=a                    " This is controversial, I know (it's just mouse support)
set nomodeline                 " I don't use them, and they've been dangerous before
set splitright                 " Split the _right_ way
set splitbelow                 " Split the _below..._ way...
set incsearch                  " incremental searching
set ignorecase                 " ignore case in searching
set scrolloff=10               " Show next 10 lines while scrolling.
set fillchars=vert:%           " see splits a bit better
set noequalalways              " Don't try to make pages the same size
set smartcase                  " Ignore case unless there's a capital
" set nowrapscan                 " I'm tryring this out mostly for end conditions in macros, but also, like, I'm a big kid and can search backward on my own.
set nojoinspaces               " don't add an extra space between '.' and other chars when joining lines
