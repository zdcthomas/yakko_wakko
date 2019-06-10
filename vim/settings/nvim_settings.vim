set termguicolors
set lazyredraw                        " macros do not have to redraw the screen

nnoremap <leader>tl      :split +terminal<cr>

nnoremap <leader>tj      :vsplit +terminal<cr>
tnoremap <leader><Esc>          <c-\><c-n>

" makes widmenu nice
set wildmenu
set wildmode=longest:full,full
set cmdheight=1

