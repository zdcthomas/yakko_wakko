let mapleader = " "


" remaps for the sake of civility
nnoremap ; :

" I rarely use these tbh
imap <C-h> <C-o>h
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l

" Indent easily 
xnoremap < <gv
xnoremap > >gv

" Easier window motions
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <Leader>wj <C-W><C-J>
nnoremap <Leader>wk <C-W><C-K>
nnoremap <Leader>wl <C-W><C-L>
nnoremap <Leader>wh <C-W><C-H>

" I usually prefer the arrow keys
nnoremap <Leader>wJ <C-W>J
nnoremap <Leader>wK <C-W>K
nnoremap <Leader>wH <C-W>H
nnoremap <Leader>wL <C-W>L

" We don't need no stinkin arrows
nnoremap <Up> :res -10<Cr>
nnoremap <Down> :res +10<Cr>
nnoremap <Left> :vertical resize +10<Cr>
nnoremap <Right> :vertical resize -10<Cr>

" Easy window creation
nnoremap <Leader>w<Leader>l :vsp<CR>
nnoremap <Leader>w<Leader>j :sp<CR>

" Circular window nav
nnoremap <tab> gt

