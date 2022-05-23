vim.keymap.set("n", "<Leader>wl", ":vsp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>wj", ":sp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-W><C-J>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-W><C-k>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-W><C-l>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<C-W><C-h>", { noremap = true, silent = true })

vim.keymap.set("n", "<Leader>wL", "<C-W>L", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>wK", "<C-W>K", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>wJ", "<C-W>J", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>wH", "<C-W>H", { noremap = true, silent = true })

vim.keymap.set("n", "<Up>", ":res +5<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", ":res -5<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Left>", ":vertical resize -5<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Right>", ":vertical resize +5<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-n>", ":let @/=expand('<cword>')<cr>cgn", { noremap = true, silent = true })
vim.keymap.set("n", "Q", "<nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>yf", ":Yf<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>yF", ":YF<Cr>", { noremap = true, silent = true })

vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })

vim.keymap.set("i", "<C-A>", "<c-o>^", { noremap = true })
vim.keymap.set("i", "<C-E>", "<c-o>$", { noremap = true })
vim.keymap.set("i", "<C-B>", "<Left>", { noremap = true })
vim.keymap.set("i", "<C-F>", "<Right>", { noremap = true })
vim.keymap.set("i", "<A-f>", "<Esc>lwi", { noremap = true })
vim.keymap.set("i", "<A-b>", "<c-o>b", { noremap = true })

vim.keymap.set("x", ".", ":norm .<cr>", { noremap = true })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = false })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = false })
vim.keymap.set("n", "<Leader><Leader>q", function()
	vim.diagnostic.set_loclist()
end, {
	noremap = true,
	silent = false,
})
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = false })
