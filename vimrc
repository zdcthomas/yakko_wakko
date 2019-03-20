set nocp

syntax on

colorscheme gruvbox
set termguicolors

set clipboard=unnamed 
set nowrap                            " don't wrap lines
set tabstop=2 shiftwidth=2            " a tab is two spaces (or set this to 4)
set expandtab                         " use spaces, not tabs (optional)
set backspace=indent,eol,start        " backspace through everything in insert mode
set autoindent
set copyindent
" set number
set showmatch
set smarttab
set title
set nobackup
set noswapfile
set nohlsearch
set nu rnu                            " set abs number on current line, but relative everywhere else
set lazyredraw                        " macros do not have to redraw the screen

if !&scrolloff
    set scrolloff=5                   " Show next 5 lines while scrolling.
endif

" makes widmenu nice
set wildmenu
set wildmode=longest:full,full
set cmdheight=1

" Searching
set incsearch                         " incremental searching
set ignorecase                        " ignore case in searching

" color of selectable letter background
hi link EasyMotionTarget Function
hi link EasyMotionShade  Comment

" remaps for the sake of civility
let mapleader = " "
nnoremap ; :

" Easymotion stuff
let g:EasyMotion_smartcase = 1
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)


" easier window motions
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <Leader>w <C-w>
