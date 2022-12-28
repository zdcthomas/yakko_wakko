return {
	"stevearc/dressing.nvim",
	event = "BufReadPost",
	config = function()
		require("dressing").setup({
			input = {
				enabled = true,
				default_prompt = "➤ ",
				insert_only = false,

				-- These are passed to nvim_open_win
				anchor = "SW",
				relative = "cursor",
				border = "rounded",
			},
			select = {
				enabled = true,
				backend = { "builtin", "telescope", "nui" },
			},
		})
	end,
}
