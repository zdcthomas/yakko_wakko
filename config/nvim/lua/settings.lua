-- maps leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nvim recently introduced entirely-in-lua filetype detection to do away with
-- the slower `filetype.vim` which is the default.
-- https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.g.diminactive_enable_focus = 1

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.copyindent = true
vim.opt.cursorline = true
vim.opt.encoding = "UTF-8"
vim.opt.equalalways = false
vim.opt.expandtab = true
vim.opt.fillchars = {
	eob = " ",
	vert = "║",
	horiz = "═",
	horizup = "╩",
	horizdown = "╦",
	vertleft = "╣",
	vertright = "╠",
	verthoriz = "╬",
}
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.modeline = false
vim.opt.mouse = { h = true, a = true }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shell = "sh"
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.signcolumn = "auto:1"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undodir = vim.fn.expand("~/.vim/undo")
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.virtualedit = "block"
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.pumblend = 25

vim.diagnostic.config({
	header = false,
	float = {
		source = "always",
		border = "rounded",
	},
	signs = false,
	virtual_text = true,
	underline = true,
	update_in_insert = false,
})
