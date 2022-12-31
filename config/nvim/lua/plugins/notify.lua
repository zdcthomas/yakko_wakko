return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
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
	end,
}
