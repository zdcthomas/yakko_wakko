-- ._____. ._____. ._____________________________________________________________________. ._____. ._____.
-- | ._. | | ._. | | ._________________________________________________________________. | | ._. | | ._. |
-- | !_| |_|_|_! | | !_________________________________________________________________! | | !_| |_|_|_! |
-- !___| |_______! !_____________________________________________________________________! !___| |_______!
-- .___|_|_| |_________________________________________________________________________________|_|_| |___.
-- | ._____| |_____________________________________________________________________________________| |_. |
-- | !_! | | |                                                                                 | | ! !_! |
-- !_____! | | Welcome to my init.lua!  The primary files around these parts are the ftplugin  | | !_____!
-- ._____. | |  cohort, and the plugins file with all the configs it requires.  Normally all   | | ._____.
-- | ._. | | | the configs for the plugins live in the packer:use's config, HOWEVER, impatient | | | ._. |
-- | | | | | |   needs to be loaded first before anything else, so that breaks the rules...    | | | | | |
-- | | | | | |                                                                                 | | | | | |
-- | | | | | |  Hopefully the nvim autocmd api comes out soon to remove the last remnants of   | | | | | |
-- | !_! | | |                         vimscript from the whole thing                          | | ! !_! |
-- !_____! | |                                                                                 | | !_____!
-- ._____. | |                                                                                 | | ._____.
-- | ._. | | |                                                                       ZT        | | | ._. |
-- | !_| |_|_|_________________________________________________________________________________| |_|_|_! |
-- !___| |_____________________________________________________________________________________| |_______!
-- .___|_|_| |___. ._____________________________________________________________________. .___|_|_| |___.
-- | ._____| |_. | | ._________________________________________________________________. | | ._____| |_. |
-- | !_! | | !_! | | !_________________________________________________________________! | | !_! | | !_! |
-- !_____! !_____! !_____________________________________________________________________! !_____! !_____!

-- require("impatient")
vim.g.mapleader = " "

-- local disabled_built_ins = {
-- 	"gzip",
-- 	"zip",
-- 	"zipPlugin",
-- 	"tar",
-- 	"tarPlugin",
-- 	"2html_plugin",
-- 	"rrhelper",
-- }

-- for _, plugin in pairs(disabled_built_ins) do
-- 	vim.g["loaded_" .. plugin] = 1
-- end

vim.cmd([[
  augroup personal
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=350, on_visual=true}
    autocmd FocusGained * checktime
  augroup END

  command! Yf :let @+ = expand("%") . ":" . line(".")
  command! Irulan :!dmux ~/irulan/wiki
]])

function Pr(data)
	print(vim.inspect(data))
end

if pcall(require, "plenary") then
	RELOAD = require("plenary.reload").reload_module

	R = function(name)
		RELOAD(name)
		return require(name)
	end
end

vim.o.autoindent = true
vim.o.autoread = true
vim.o.backspace = "indent,eol,start"
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.copyindent = true
vim.o.cursorline = true
vim.o.encoding = "UTF-8"
vim.o.equalalways = false
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.lazyredraw = true
vim.o.modeline = false
vim.o.mouse = "ha"
vim.o.number = true
vim.o.scrolloff = 5
vim.o.shell = "sh"
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.signcolumn = "auto:1"
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undodir = vim.fn.expand("~/.vim/undo")
vim.o.undofile = true
vim.o.updatetime = 100
vim.o.wrap = false
vim.o.wildmenu = true

vim.g.diminactive_enable_focus = 1
vim.g.netrw_preview = 1 -- preview window shown in a vertically split window. Also affects the "previous window" (see |netrw-P|) in the same way.

vim.api.nvim_set_keymap("n", "<Leader>wl", ":vsp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>wj", ":sp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-W><C-J>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-W><C-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W><C-l>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W><C-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Up>", ":res +5<Cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", ":res -5<Cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", ":vertical resize -5<Cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", ":vertical resize +5<Cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":let @/=expand('<cword>')<cr>cgn", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>yf", ":Yf<Cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", { noremap = true })

vim.api.nvim_set_keymap("i", "<C-A>", "<c-o>^", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-B>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-F>", "<Right>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-f>", "<Esc>lwi", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-b>", "<Esc>bi", { noremap = true })

vim.api.nvim_set_keymap("x", ".", ":norm .<cr>", { noremap = true })

vim.api.nvim_set_keymap("t", "<leader><esc>", "<c-><c-n>", { noremap = true })

require("plugins")
