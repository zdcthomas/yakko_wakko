return {
	"stevearc/dressing.nvim",
	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
	opts = {
		input = {
			default_prompt = "➤ ",
			insert_only = false,
			start_in_insert = false,
			-- These are passed to nvim_open_win
			relative = "cursor",
			border = "rounded",
		},
		select = {
			backend = { "builtin", "nui", "telescope", "fzf_lua", "fzf" },
			builtin = {
				-- Display numbers for options and set up keymaps
				show_numbers = true,
				-- These are passed to nvim_open_win
				border = "double",
				-- 'editor' and 'win' will default to being centered
				relative = "cursor",

				buf_options = {},
				win_options = {
					cursorline = true,
					cursorlineopt = "both",
				},

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- the min_ and max_ options can be a list of mixed types.
				-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
				-- width = nil,
				-- max_width = { 140, 0.8 },
				-- min_width = { 40, 0.2 },
				-- height = nil,
				-- max_height = 0.9,
				-- min_height = { 10, 0.2 },

				-- Set to `false` to disable
				mappings = {
					["<Esc>"] = "Close",
					["q"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},

				-- override = function(conf)
				-- 	-- This is the config that will be passed to nvim_open_win.
				-- 	-- Change values here to customize the layout
				-- 	return conf
				-- end,
			},
		},
	},
}
