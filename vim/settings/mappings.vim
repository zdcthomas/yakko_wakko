let mapleader = " "


" remaps for the sake of civility
nnoremap ; :
" nnoremap - :Explore<Cr>

imap <C-h> <C-o>h
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l

" indent easily 
xnoremap < <gv
xnoremap > >gv

" easier window motions
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <Leader>wj <C-W><C-J>
nnoremap <Leader>wk <C-W><C-K>
nnoremap <Leader>wl <C-W><C-L>
nnoremap <Leader>wh <C-W><C-H>

nnoremap <Leader>wJ :res -10<Cr>
nnoremap <Leader>wK :res +10<Cr>
nnoremap <Leader>wH :vertical resize +10<Cr>
nnoremap <Leader>wL :vertical resize -10<Cr>

nnoremap <Up> :res -10<Cr>
nnoremap <Down> :res +10<Cr>
nnoremap <Left> :vertical resize +10<Cr>
nnoremap <Right> :vertical resize -10<Cr>

nnoremap <Leader>w<Leader>l :vsp<CR>
nnoremap <Leader>w<Leader>j :sp<CR>
"
 " Circular window nav
nnoremap <tab> gt

