--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		keys = {
			{
				"<leader>fs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		---@type snacks.Config
		opts = {
			bigfile = {
				-- notify = true, -- show notification when big file detected
				size = 1.5 * 1024 * 1024, -- 1.5MB
				-- Enable or disable features when big file detected
				---@param ctx {buf: number, ft:string}
				setup = function(ctx)
					vim.b.minianimate_disable = true
					vim.schedule(function()
						vim.bo[ctx.buf].syntax = ctx.ft
					end)
				end,
			},
			statuscolumn = { enabled = false },
			quickfile = { enabled = true },
			words = { enabled = false },
		},
		keys = {
			-- {
			-- 	"<leader>un",
			-- 	function()
			-- 		Snacks.notifier.hide()
			-- 	end,
			-- 	desc = "Dismiss All Notifications",
			-- },
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>GB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
			},
			{
				"<leader>gh",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Lazygit Current File History",
			},
			-- {
			-- 	"<leader>cR",
			-- 	function()
			-- 		Snacks.rename()
			-- 	end,
			-- 	desc = "Rename File",
			-- },
			-- {
			-- 	"<c-/>",
			-- 	function()
			-- 		Snacks.terminal()
			-- 	end,
			-- 	desc = "Toggle Terminal",
			-- },
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
			},
			-- {
			-- 	"<leader>N",
			-- 	desc = "Neovim News",
			-- 	function()
			-- 		Snacks.win({
			-- 			file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
			-- 			width = 0.6,
			-- 			height = 0.6,
			-- 			wo = {
			-- 				border = "rounded",
			-- 				-- spell = false,
			-- 				-- wrap = false,
			-- 				-- signcolumn = "yes",
			-- 				-- conceallevel = 3,
			-- 			},
			-- 		})
			-- 	end,
			-- },
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		cmd = {
			"GrugFar",
		},
		opts = {
			-- debounce milliseconds for issuing search while user is typing
			-- prevents excesive searching
			debounceMs = 500,

			-- minimum number of chars which will cause a search to happen
			-- prevents performance issues in larger dirs
			minSearchChars = 2,

			-- max number of parallel replacements tasks
			maxWorkers = 4,

			-- extra args that you always want to pass to rg
			-- like for example if you always want context lines around matches
			extraRgArgs = "",

			-- buffer line numbers + match line numbers can get a bit visually overwhelming
			-- turn this off if you still like to see the line numbers
			disableBufferLineNumbers = true,

			-- maximum number of search chars to show in buffer and quickfix list titles
			-- zero disables showing it
			maxSearchCharsInTitles = 30,

			-- shortcuts for the actions you see at the top of the buffer
			-- set to '' to unset. Unset mappings will be removed from the help header
			keymaps = {
				replace = "<c-z>",
				qflist = "<C-q>",
				gotoLocation = "<enter>",
				syncLocations = "<C-s>",
				close = "<C-x>",
			},

			-- separator between inputs and results, default depends on nerdfont
			resultsSeparatorLineChar = "",

			-- spinner states, default depends on nerdfont, set to false to disable
			spinnerStates = {
				"󱑋 ",
				"󱑌 ",
				"󱑍 ",
				"󱑎 ",
				"󱑏 ",
				"󱑐 ",
				"󱑑 ",
				"󱑒 ",
				"󱑓 ",
				"󱑔 ",
				"󱑕 ",
				"󱑖 ",
			},

			-- icons for UI, default ones depend on nerdfont
			-- set individul ones to '' to disable, or set enabled = false for complete disable
			icons = {
				-- whether to show icons
				enabled = true,

				searchInput = " ",
				replaceInput = " ",
				filesFilterInput = " ",
				flagsInput = "󰮚 ",

				resultsStatusReady = "󱩾 ",
				resultsStatusError = " ",
				resultsStatusSuccess = "󰗡 ",
				resultsActionMessage = "  ",
			},

			-- placeholders to show in inpuut areas when they are empty
			-- set individul ones to '' to disable, or set enabled = false for complete disable
			placeholders = {
				-- whether to show placeholders
				enabled = true,

				search = "ex: foo    foo([a-z0-9]*)    fun\\(",
				replacement = "ex: bar    ${1}_foo    $$MY_ENV_VAR ",
				filesGlob = "ex: *.lua     *.{css,js}    **/docs/*.md",
				flags = "ex: --help --hidden (-.) --ignore-case (-i) --multiline (-U) --fixed-strings (-F)",
			},
		},
	},
	{
		"echasnovski/mini.splitjoin",
		version = false,
		keys = { {
			"gS",
			mode = { "n", "x" },
		} },
		config = function()
			require("mini.splitjoin").setup()
		end,
	},
	{ "mechatroner/rainbow_csv", ft = "csv" },

	{
		"MisanthropicBit/decipher.nvim",
		opts = {
			active_codecs = "all", -- Set all codecs as active and useable
			float = { -- Floating window options
				padding = 0, -- Zero padding (does not apply to title if any)
				border = { -- Floating window border
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				mappings = {
					close = "q", -- Key to press to close the floating window
					apply = "a", -- Key to press to apply the encoding/decoding
					jsonpp = "J", -- Key to prettily format contents as json if possbile
					help = "?", -- Toggle help
				},
				title = true, -- Display a title with the codec name
				title_pos = "left", -- Position of the title
				autoclose = true, -- Autoclose floating window if insert
				-- mode is activated or the cursor is moved
				enter = false, -- Automatically enter the floating window if
				-- opened
				options = {}, -- Options to apply to the floating window contents
			},
		},
	},
}
