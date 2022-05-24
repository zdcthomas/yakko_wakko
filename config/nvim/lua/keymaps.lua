vim.keymap.set("n", "<Leader>wl", ":vsp<CR>", { silent = true, desc = "Split right" })
vim.keymap.set("n", "<Leader>wj", ":sp<CR>", { silent = true, desc = "Split down" })
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
vim.keymap.set("n", "<Leader>yf", ":Yf<Cr>", { silent = true, desc = "copy file patth to clipboard" })
vim.keymap.set("n", "<Leader>yF", ":YF<Cr>", { silent = true, desc = "copy file path with line no to clipboard" })

vim.keymap.set("c", "<C-a>", "<Home>", {})
vim.keymap.set("c", "<C-e>", "<End>", {})

vim.keymap.set("i", "<C-A>", "<c-o>^", {})
vim.keymap.set("i", "<C-E>", "<c-o>$", {})
vim.keymap.set("i", "<C-B>", "<Left>", {})
vim.keymap.set("i", "<C-F>", "<Right>", {})
vim.keymap.set("i", "<A-f>", "<Esc>lwi", {})
vim.keymap.set("i", "<A-b>", "<c-o>b", {})

vim.keymap.set("x", ".", ":norm .<cr>", {})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = false })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = false })
vim.keymap.set("n", "<Leader><Leader>q", function()
	vim.diagnostic.set_loclist()
end, {
	silent = false,
	desc = "Send diagnostics to location list",
})
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { silent = false, desc = "Show diagnostic in float" })
local wk = require("which-key")
wk.register({
	["<leader>"] = {
		w = {
			name = "window", -- optional group name
		},
	},
})
