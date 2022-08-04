vim.keymap.set("n", "<Leader>wl", ":rightbelow vsp<CR>", { silent = true, desc = "Split right" })
vim.keymap.set("n", "<Leader>wh", ":leftabove vsp<CR>", { silent = true, desc = "Split right" })
vim.keymap.set("n", "<Leader>wk", ":leftabove sp<CR>", { silent = true, desc = "Split right" })
vim.keymap.set("n", "<Leader>wj", ":rightbelow sp<CR>", { silent = true, desc = "Split down" })
vim.keymap.set("n", "<C-j>", "<C-W><C-J>", { silent = true, desc = "select window below" })
vim.keymap.set("n", "<C-k>", "<C-W><C-k>", { silent = true, desc = "select window above" })
vim.keymap.set("n", "<C-l>", "<C-W><C-l>", { silent = true, desc = "select window to the right" })
vim.keymap.set("n", "<C-h>", "<C-W><C-h>", { silent = true, desc = "select window to the left" })

vim.keymap.set("n", "<Leader>wL", "<C-W>L", { silent = true, desc = "Move window right" })
vim.keymap.set("n", "<Leader>wK", "<C-W>K", { silent = true, desc = "Move window up" })
vim.keymap.set("n", "<Leader>wJ", "<C-W>J", { silent = true, desc = "Move window down" })
vim.keymap.set("n", "<Leader>wH", "<C-W>H", { silent = true, desc = "Move window left" })

vim.keymap.set("n", "<Up>", ":res +5<Cr>", { silent = true })
vim.keymap.set("n", "<Down>", ":res -5<Cr>", { silent = true })
vim.keymap.set("n", "<Left>", ":vertical resize -5<Cr>", { silent = true })
vim.keymap.set("n", "<Right>", ":vertical resize +5<Cr>", { silent = true })
vim.keymap.set("n", "<C-n>", ":let @/=expand('<cword>')<cr>cgn", { silent = true })
vim.keymap.set("n", "Q", "<nop>", { silent = true })
vim.keymap.set("n", "<Leader>yf", ":Yf<Cr>", { silent = true, desc = "copy file path to clipboard" })
vim.keymap.set("n", "<Leader>yF", ":YF<Cr>", { silent = true, desc = "copy file path with line no to clipboard" })

vim.keymap.set("i", "<C-A>", "<c-o>^", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-E>", "<c-o>$", { desc = "End of line" })
vim.keymap.set("i", "<C-B>", "<Left>", { desc = "Move 1 char left" })
vim.keymap.set("i", "<C-F>", "<Right>", { desc = "Move 1 char right" })
vim.keymap.set("i", "<A-f>", "<Esc>lwi", { desc = "Move 1 `word` right" })
vim.keymap.set("i", "<A-b>", "<c-o>b", { desc = "Move 1 `word` left" })

vim.keymap.set("x", ".", ":norm .<cr>", {})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = false, desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = false, desc = "Go to next diagnostic" })
vim.keymap.set("n", "<Leader><Leader>q", function()
	vim.diagnostic.set_loclist()
end, {
	silent = false,
	desc = "Send diagnostics to location list",
})
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { silent = false, desc = "Show diagnostic in float" })
local remove_qf_item = function()
	local current_quick_fix_index = vim.fn.line(".")
	local quickfix_list = vim.fn.getqflist()
	table.remove(quickfix_list, current_quick_fix_index)
	vim.fn.setqflist(quickfix_list, "r")
	vim.cmd("execute " .. current_quick_fix_index .. "cfirst")
end

-- TODO: add autocmd to qf list ft

vim.cmd([[
  " When using `dd` in the quickfix list, remove the item from the quickfix list.
  function! RemoveQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . "cfirst"
    :copen
  endfunction
  :command! RemoveQFItem :call RemoveQFItem()
  " Use map <buffer> to only map dd in the quickfix window. Requires +localmap
  autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
]])
