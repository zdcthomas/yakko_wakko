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
InitGroupId = vim.api.nvim_create_augroup("InitGroup", { clear = true })
vim.g.mapleader = " "
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- vim.filetype.add({
-- 	extension = {
-- 		lua = "lua",
-- 	},
-- })

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
local levels = {
	errors = vim.diagnostic.severity.ERROR,
	warnings = vim.diagnostic.severity.WARN,
	info = vim.diagnostic.severity.INFO,
	hints = vim.diagnostic.severity.HINT,
}

function GetAllDiagnostics(bufnr)
	local result = {}
	for k, level in pairs(levels) do
		result[k] = #vim.diagnostic.get(bufnr, { severity = level })
	end

	return result
end

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
vim.opt.signcolumn = "auto:1"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undodir = vim.fn.expand("~/.vim/undo")
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.wrap = false
vim.opt.wildmenu = true
vim.opt.showmode = false
vim.opt.smartindent = true

vim.g.diminactive_enable_focus = 1
-- preview window shown in a vertically split window. Also affects the "previous window" (see |netrw-P|) in the same way.
vim.g.netrw_preview = 1

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

vim.api.nvim_create_autocmd("FileType", {
	group = InitGroupId,
	pattern = { "gitcommit", "gitrebase" },
	command = "startinsert",
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = InitGroupId,
	callback = function()
		-- set colorscheme after options
		-- vim.api.nvim_set_hl(0, "WinSeperator", { guibg = "None" })
		vim.cmd("highlight WinSeparator guibg=None")
	end,
})

require("plugins")

vim.cmd("colorscheme kanagawa")
