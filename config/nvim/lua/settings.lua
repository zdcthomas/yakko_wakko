-- maps leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.netrw_list_hide = ""
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.laststatus = 3
vim.opt.copyindent = true
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
vim.opt.shell = "bash"
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
vim.opt.cmdheight = 0
-- vim.opt.path:append("**")

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

-- doesn't work right since most ftplugins redefine formatoptions
vim.opt.formatoptions = vim.tbl_extend("force", vim.opt.formatoptions:get(), {
	c = false,
	o = false, -- O and o, don't continue comments
	r = true, -- Pressing Enter will continue comments
})

-- TODO: link this to a non cmp highlight, it's for netrw
vim.cmd([[
hi link netrwMarkFile CmpItemAbbrMatchFuzzy
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
]])

vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
-- vim.g.loaded_zip = 1
-- vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1
