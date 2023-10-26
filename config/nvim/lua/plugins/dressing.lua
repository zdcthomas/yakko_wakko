return {
	"stevearc/dressing.nvim",
	-- event = "BufReadPost",
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
			enabled = true,
			default_prompt = "➤ ",
			insert_only = false,

			-- These are passed to nvim_open_win
			relative = "cursor",
			border = "rounded",
		},
		select = {
			enabled = true,
			backend = { "builtin", "telescope", "nui" },
		},
	},
}
