local map = vim.keymap.set
local function append(char)
	return [[:s/\(.\)$/\1]] .. char .. [[/<cr>]]
end

map("n", "<LocalLeader>,", append(","), { silent = true, desc = "Append comma" })
map("n", "<LocalLeader>;", append(";"), { silent = true, desc = "Append semicolon" })

map("n", "<Leader>wl", ":rightbelow vsp<CR>", { silent = true, desc = "Split right" })
map("n", "<Leader>wh", ":leftabove vsp<CR>", { silent = true, desc = "Split left" })
map("n", "<Leader>wk", ":leftabove sp<CR>", { silent = true, desc = "Split up" })
map("n", "<Leader>wj", ":rightbelow sp<CR>", { silent = true, desc = "Split down" })
map("n", "<C-j>", "<C-W><C-J>", { silent = true, desc = "select window below" })
map("n", "<C-k>", "<C-W><C-k>", { silent = true, desc = "select window above" })
map("n", "<C-l>", "<C-W><C-l>", { silent = true, desc = "select window to the right" })
map("n", "<C-h>", "<C-W><C-h>", { silent = true, desc = "select window to the left" })

map("n", "<Leader>wL", "<C-W>L", { silent = true, desc = "Move window right" })
map("n", "<Leader>wK", "<C-W>K", { silent = true, desc = "Move window up" })
map("n", "<Leader>wJ", "<C-W>J", { silent = true, desc = "Move window down" })
map("n", "<Leader>wH", "<C-W>H", { silent = true, desc = "Move window left" })

map("n", "[q", "<cmd>cp<cr>", { silent = true, desc = "goto prev entry in qf" })
map("n", "]q", "<cmd>cn<cr>", { silent = true, desc = "goto next entry in qf" })
map("n", "<Up>", ":res +5<Cr>", { silent = true })
map("n", "<Down>", ":res -5<Cr>", { silent = true })
map("n", "<Left>", ":vertical resize -5<Cr>", { silent = true })
map("n", "<Right>", ":vertical resize +5<Cr>", { silent = true })
map("n", "<C-n>", ":let @/=expand('<cword>')<cr>cgn", { silent = true })
map("n", "Q", "<nop>", { silent = true })

map("n", "<Leader>yf", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
end, { silent = true, desc = "copy file path to clipboard" })
map("n", "<Leader>yF", function()
	vim.fn.setreg("+", vim.fn.expand("%") + ":" + vim.fn.line("."))
end, { silent = true, desc = "copy file path with line no to clipboard" })

map("n", "<Leader>@", function()
	local reg = vim.fn.getcharstr()
	local reg_content = vim.fn.getreg(reg)
	local replaced_reg_content = vim.fn.input("> ", reg_content)
	vim.fn.setreg(reg, replaced_reg_content)
end, { silent = true, desc = "Edit a macro" })

map("i", "<C-A>", "<c-o>^", { desc = "Beginning of line" })
map("i", "<C-E>", "<c-o>$", { desc = "End of line" })
map("i", "<C-B>", "<Left>", { desc = "Move 1 char left" })
map("i", "<C-F>", "<Right>", { desc = "Move 1 char right" })
map("i", "<A-f>", "<Esc>lwi", { desc = "Move 1 `word` right" })
map("i", "<A-b>", "<c-o>b", { desc = "Move 1 `word` left" })

map("x", ".", ":norm .<cr>", {})

map("n", "[d", function()
	vim.diagnostic.goto_prev({ wrap = false })
end, { silent = false, desc = "Go to previous diagnostic" })
map("n", "]d", function()
	vim.diagnostic.goto_next({ wrap = false })
end, { silent = false, desc = "Go to next diagnostic" })

map("n", "[e", function()
	vim.diagnostic.goto_prev({ wrap = false, severity = vim.diagnostic.severity.ERROR })
end, { silent = false, desc = "Go to previous diagnostic" })
map("n", "]e", function()
	vim.diagnostic.goto_next({ wrap = false, severity = vim.diagnostic.severity.ERROR })
end, { silent = false, desc = "Go to next diagnostic" })
map("n", "<Leader>q", function()
	local all = { -- ALL
		vim.diagnostic.severity.ERROR,
		vim.diagnostic.severity.WARN,
		vim.diagnostic.severity.INFO,
		vim.diagnostic.severity.HINT,
	}

	local sevs = {
		e = vim.diagnostic.severity.ERROR,
		w = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
	}

	local level = sevs[vim.fn.getcharstr()] or all
	vim.diagnostic.setqflist({ severity = level })
end, {
	silent = false,
	desc = "Send diagnostics to location list",
})

map("n", "<Leader>e", vim.diagnostic.open_float, { silent = false, desc = "Show diagnostic in float" })

map("c", "<C-f>", '<C-R>=expand("%:p")<CR>', { silent = false })
map("c", "<C-a>", "<Home>", { silent = false })
map("c", "<C-e>", "<End>", { silent = false })
map("c", "<C-h>", "<Left>", { silent = false })
map("c", "<C-j>", "<Down>", { silent = false })
map("c", "<C-k>", "<Up>", { silent = false })
map("c", "<C-l>", "<Right>", { silent = false })
map("c", "<C-d>", "<Del>", { silent = false })

-- let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

-- nnoremap cn *``cgn
-- nnoremap cN *``cgN

-- vnoremap <expr> cn g:mc . "``cgn"
-- vnoremap <expr> cN g:mc . "``cgN"

-- function! SetupCR()
--   nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
-- endfunction

-- nnoremap cq :call SetupCR()<CR>*``qz
-- nnoremap cQ :call SetupCR()<CR>#``qz

-- vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
-- vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
