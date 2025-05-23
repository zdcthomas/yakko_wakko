vim.g.format_on_save = true
-- This is NOT a builtin var of any meaning, grep for it in this repo to see how it works!

-- vim.opt.winborder = "rounded"
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.clipboard:append("unnamedplus")
vim.opt.laststatus = 3
vim.opt.copyindent = true
vim.opt.encoding = "UTF-8"
vim.opt.splitkeep = "cursor"
vim.opt.equalalways = false
vim.opt.expandtab = true
vim.opt.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add"
vim.opt.spelllang = { "en_us" }
vim.opt.fillchars = {
	eob = " ",
	vert = "║",
	horiz = "═",
	horizup = "╩",
	horizdown = "╦",
	vertleft = "╣",
	vertright = "╠",
	verthoriz = "╬",
	-- stl = "─",
	-- stlnc = "─",
}
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.modeline = false
vim.opt.mouse = {
	n = true,
	v = true,
	-- i = false,
	-- c = false,
	-- h = false,
	-- a = false,
	-- r = false,
}
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
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undo/")
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.virtualedit = "block"

---- Folds
-- vim.opt.foldmethod = "expr"
vim.opt.foldtext = ""
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldnestmax = 4
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
-- vim.g.markdown_folding = 2 -- enable markdown folding
------

vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.cmdheight = 0

vim.diagnostic.config({
	header = false,
	float = {
		source = "if_many",
		border = "rounded",
	},
	severity_sort = true,
	signs = false,
	underline = true,
	update_in_insert = true,
	virtual_text = true,
})

-- doesn't work right since most ftplugins redefine formatoptions
vim.opt.formatoptions = vim.tbl_extend("force", vim.opt.formatoptions:get(), {
	c = false,
	o = false, -- O and o, don't continue comments
	r = true, -- Pressing Enter will continue comments
})

--  ---------------
--  |    NETRW    |
--  ---------------

-- TODO: link this to a non cmp highlight, it's for netrw
vim.g.netrw_list_hide = ""
vim.cmd([[
  hi link netrwMarkFile CmpItemAbbrMatchFuzzy
  " set Vim-specific sequences for RGB colors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]])

vim.filetype.add({
	extension = {
		gleam = "gleam",
		nix = "nix",
		hurl = "hurl",
	},
	pattern = {
		[".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
	},
	-- 	["*/.github/*.yaml"] = { "github", "yaml" },
	-- },
})

vim.cmd([[
  highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
  highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
  highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
  highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]])

function Foo()
	local todos = 0
	local all_files = require("orgmode.api").load()
	for key, file in pairs(all_files) do
		for key, headline in pairs(file.headlines) do
			if headline.todo_type == "TODO" then
				todos = todos + 1
			end
		end
	end
	vim.print(todos)
end
