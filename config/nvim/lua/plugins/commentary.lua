return {
	-- {
	-- 	"echasnovski/mini.comment",
	-- 	keys = {
	-- 		{ "gc", mode = { "o", "n", "x" } },
	-- 		{ "gcc", mode = { "n", "x" } },
	-- 	},
	-- 	opts = {
	-- 		options = {
	-- 			custom_commentstring = function()
	-- 				return require("ts_context_commentstring.internal").calculate_commentstring()
	-- 					or vim.bo.commentstring
	-- 			end,
	-- 		},
	-- 	},
	-- },
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = {
			{ "gc", mode = { "n", "x" } },
			{ "gb", mode = { "n", "x" } },
			{ "gcA", mode = { "n", "x" } },
			{ "gco", mode = { "n", "x" } },
			{ "gcO", mode = { "n", "x" } },
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
}
