return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"folke/todo-comments.nvim",
		"numToStr/Comment.nvim",
	},
	event = "InsertEnter",
	config = function()
		require("plugins.luasnip.base")
	end,
}
