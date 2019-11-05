set termguicolors
set lazyredraw                        " macros do not have to redraw the screen

nnoremap <leader>t<Leader>l      :vsplit +terminal<cr>

nnoremap <leader>t<Leader>j      :split +terminal<cr>
tnoremap <leader><Esc>          <c-\><c-n>

" makes widmenu nice
set wildmenu
set wildmode=longest:full,full
set cmdheight=1

