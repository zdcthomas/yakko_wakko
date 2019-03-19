set nocp
" execute pathogen#infect()

syntax on
colorscheme desert

:let mapleader = " "
set clipboard=unnamed 
set nowrap                                                   " don't wrap lines
set tabstop=2 shiftwidth=2                                   " a tab is two spaces (or set this to 4)
set expandtab                                                " use spaces, not tabs (optional)
set backspace=indent,eol,start                               " backspace through everything in insert mode
set autoindent
set copyindent
" set number
set showmatch
set smarttab
set title
set nobackup
set noswapfile
set nohlsearch
set nu rnu
if !&scrolloff
    set scrolloff=5      " Show next 5 lines while scrolling.
endif
nnoremap ; :

"" Searching
set incsearch                   " incremental searching
set ignorecase                  " ignore case in searching
let g:EasyMotion_smartcase = 1

" set runtimepath^=~/.vim/bundle/ctrlp.vim
" map <C-n> :NERDTreeToggle<CR>
" let NERDTreeShowLineNumbers=1

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" easier window motions
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
