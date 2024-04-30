--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {

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
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },

		init = function()
			vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
				require("fzf-lua").complete_path()
			end, { silent = true, desc = "Fuzzy complete path" })

			vim.keymap.set({ "n" }, "<leader>P", function()
				require("fzf-lua").files()
			end, { silent = true, desc = "fzf find files" })
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
	{
		"codethread/qmk.nvim",
		cmd = { "QMKFormat" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("qmk").setup({
				name = "LAYOUT_preonic_grid", -- identify your layout name
				comment_preview = {
					keymap_overrides = {
						HERE_BE_A_LONG_KEY = "Magic", -- replace any long key codes
					},
				},
				-- layout = { -- create a visual representation of your final layout
				-- 	"x ^xx", -- including keys that span multple rows (with alignment left, center or right)
				-- 	"_ x x", -- pad empty cells
				-- 	"_ x x",
				-- },
			})
		end,
	},
}
