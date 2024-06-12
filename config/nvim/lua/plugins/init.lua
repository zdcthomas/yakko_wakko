--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
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
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },

		init = function()
			vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
				require("fzf-lua").complete_path()
			end, { silent = true, desc = "Fuzzy complete path" })

			vim.keymap.set({ "n" }, "<leader>p", function()
				require("fzf-lua").files()
			end, { silent = true, desc = "fzf find files" })

			vim.keymap.set({ "n" }, "<leader>b", function()
				require("fzf-lua").buffers()
			end, { silent = true, desc = "fzf find files" })

			vim.keymap.set({ "n" }, "<leader>F", function()
				require("fzf-lua").live_grep()
			end, { silent = true, desc = "fzf find" })
		end,

		config = function()
			-- calling `setup` is optional for customization
			local fzf = require("fzf-lua")
			fzf.setup({
				actions = {
					files = {
						-- instead of the default action 'actions.file_edit_or_qf'
						-- it's important to define all other actions here as this
						-- table does not get merged with the global defaults
						["default"] = fzf.actions.file_edit,
						["alt-j"] = fzf.actions.file_split,
						["alt-l"] = fzf.actions.file_vsplit,
						["alt-q"] = fzf.actions.file_sel_to_qf,
					},
				},
				git = {
					bcommits = {
						prompt = "logs:",
						cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen%><(12)%cr%><|(12)%Creset %s' <file>",
						preview = "git show --stat --color --format='%C(cyan)%an%C(reset)%C(bold yellow)%d%C(reset): %s' {1} -- <file>",
						actions = {
							["ctrl-d"] = function(...)
								fzf.actions.git_buf_vsplit(...)
								vim.cmd("windo diffthis")
								local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
								vim.api.nvim_feedkeys(switch, "t", false)
							end,
						},
						preview_opts = "nohidden",
						winopts = {
							preview = {
								layout = "vertical",
								vertical = "right:50%",
								wrap = "wrap",
							},
							row = 1,
							width = vim.api.nvim_win_get_width(0),
							height = 0.3,
						},
					},
					branches = {
						prompt = "branches:",
						cmd = "git branch --all --color",
						winopts = {
							preview = {
								layout = "vertical",
								vertical = "right:50%",
								wrap = "wrap",
							},
							row = 1,
							width = vim.api.nvim_win_get_width(0),
							height = 0.3,
						},
					},
				},
			})
		end,
	},
	-- {
	-- 	"codethread/qmk.nvim",
	-- 	cmd = { "QMKFormat" },
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("qmk").setup({
	-- 			name = "LAYOUT_preonic_grid", -- identify your layout name
	-- 			comment_preview = {
	-- 				keymap_overrides = {
	-- 					HERE_BE_A_LONG_KEY = "Magic", -- replace any long key codes
	-- 				},
	-- 			},
	-- 			-- layout = { -- create a visual representation of your final layout
	-- 			-- 	"x ^xx", -- including keys that span multple rows (with alignment left, center or right)
	-- 			-- 	"_ x x", -- pad empty cells
	-- 			-- 	"_ x x",
	-- 			-- },
	-- 		})
	-- 	end,
	-- },
}
