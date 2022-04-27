-- This file is for configs that are short. It's kind of dumb to seperate these
-- out not into their own files but for now it's what I'm trying.
local Config = {}

function Config.dressing()
	require("dressing").setup({
		input = {
			-- Set to false to disable the vim.ui.input implementation
			enabled = true,

			-- Default prompt string
			default_prompt = "➤ ",

			-- When true, <Esc> will close the modal
			insert_only = true,

			-- These are passed to nvim_open_win
			anchor = "SW",
			relative = "cursor",
			border = "rounded",
		},
		select = { enabled = false },
	})
end

function Config.hardtime()
	vim.g.hardtime_default_on = 1
	vim.g.list_of_normal_keys = { "h", "j", "k", "l", "x" }
	vim.g.list_of_visual_keys = { "h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }
	vim.g.list_of_insert_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }
	vim.g.list_of_disabled_keys = {}
	vim.g.hardtime_timeout = 1000

	vim.g.hardtime_showmsg = 0
	vim.g.hardtime_ignore_buffer_patterns = { "Dirvish", "help" }
	vim.g.hardtime_ignore_quickfix = 1

	vim.g.hardtime_maxcount = 3
	vim.g.hardtime_ignore_quickfix = 1
end

function Config.kanagawa()
	require("kanagawa").setup({
		undercurl = true, -- enable undercurls
		commentStyle = "italic",
		functionStyle = "NONE",
		keywordStyle = "italic",
		statementStyle = "bold",
		typeStyle = "NONE",
		variablebuiltinStyle = "italic",
		specialReturn = true, -- special highlight for the return keyword
		specialException = true, -- special highlight for exception handling keywords
		transparent = false, -- do not set background color
		dimInactive = true, -- dim inactive window `:h hl-NormalNC`
		globalStatus = true, -- adjust window separators highlight for laststatus=3
		colors = {},
		overrides = {},
	})
end

function Config.rose_pine()
	require("rose-pine").setup({
		---@usage 'main'|'moon'
		dark_variant = "moon",
		bold_vert_split = true,
		disable_float_background = false,
		groups = {
			border = "highlight_med",
			comment = "muted",
			link = "iris",
			punctuation = "subtle",

			error = "love",
			hint = "iris",
			info = "foam",
			warn = "gold",

			headings = "subtle",
			-- or set all headings at once
			-- headings = 'subtle'
		},
	})
end

function Config.venn()
	-- enable or disable keymappings for venn
	function _G.toggle_venn()
		local venn_enabled = vim.inspect(vim.b.venn_enabled)
		if venn_enabled == "nil" then
			print("venn mode activated!")
			vim.cmd("LspStop")
			vim.b.venn_enabled = true
			vim.cmd([[setlocal ve=all]])
			-- draw a line on HJKL keystokes
			vim.keymap.set("n", "J", "<C-v>j:VBox<cr>", { buffer = true, noremap = true })
			vim.keymap.set("n", "K", "<C-v>k:VBox<cr>", { buffer = true, noremap = true })
			vim.keymap.set("n", "L", "<C-v>l:VBox<cr>", { buffer = true, noremap = true })
			vim.keymap.set("n", "H", "<C-v>h:VBox<cr>", { buffer = true, noremap = true })
			-- draw a box by pressing "f" with visual selection
			vim.keymap.set("v", "f", ":VBox<cr>", { buffer = true, noremap = true })
		else
			print("venn mode disengaged!")
			vim.cmd("LspStart")
			vim.cmd([[setlocal ve=]])
			vim.cmd([[mapclear <buffer>]])
			vim.b.venn_enabled = nil
		end
	end
	-- toggle keymappings for venn using <leader>v
	vim.keymap.set("n", "<leader>v", ":lua toggle_venn()<cr>", { silent = true, noremap = true })
end

function Config.notify()
	require("notify").setup({
		stages = "slide",
		timeout = 3000,
		-- Minimum width for notification windows
		minimum_width = 30,
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
	})
	vim.notify = require("notify")
end

function Config.camelsnek()
	vim.g.camelsnek_alternative_camel_commands = 1

	vim.keymap.set("n", "crs", ":Snek<CR>", { noremap = true, silent = true })
	vim.keymap.set("x", "crs", ":Snek<CR>", { noremap = true, silent = true })

	vim.keymap.set("n", "crp", ":Pascal<CR>", { noremap = true, silent = true })
	vim.keymap.set("x", "crp", ":Pascal<CR>", { noremap = true, silent = true })

	vim.keymap.set("n", "crc", ":Camel<CR>", { noremap = true, silent = true })
	vim.keymap.set("x", "crc", ":Camel<CR>", { noremap = true, silent = true })

	vim.keymap.set("n", "crk", ":Kebab<CR>", { noremap = true, silent = true })
	vim.keymap.set("x", "crk", ":Kebab<CR>", { noremap = true, silent = true })
end

function Config.autopairs()
	require("nvim-autopairs").setup({
		fast_wrap = {},
		check_ts = true,
		disable_in_macro = true,
	})
end

function Config.dirvish()
	vim.g.loaded_netrwPlugin = 1
	vim.cmd([[
    command! -nargs=? -complete=dir Explore Dirvish <args>
    command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
    command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
  ]])
	vim.g.dirvish_mode = ":sort | sort ,^.*[^/]$, r"
end

function Config.md_links()
	require("follow-md-links")
	vim.keymap.set("", "<bs>", ":edit #<cr>", { noremap = true, silent = true })
end

function Config.easy_align()
	vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
	vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
end

function Config.git_signs()
	require("gitsigns").setup({
		signs = {
			add = { hl = "GitSignsAdd", text = ">", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		numhl = true,
		keymaps = {
			["n <leader>gn"] = '<cmd>lua require"gitsigns.actions".next_hunk()<CR>',
			["n <leader>gp"] = '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>',
			["n <leader>ga"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			["v <leader>ga"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			["n <leader>gr"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			["n <leader>gu"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			["n <leader>gs"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
			["n <leader>gc"] = '<cmd>lua require"gitsigns".setqflist("all")<CR>',
			["n <leader><leader>g"] = '<cmd>lua require("config.modes.git_sign_mode")()<CR>',
			["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
			["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
		},
	})
end

return Config
