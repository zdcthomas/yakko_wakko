return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"folke/todo-comments.nvim",
	},
	event = "InsertEnter",
	config = function()
		require("config.luasnip")
	end,
}
