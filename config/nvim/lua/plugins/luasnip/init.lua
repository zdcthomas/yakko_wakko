return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"folke/todo-comments.nvim",
		{
			"numToStr/Comment.nvim",
			dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
			opts = {
				pre_hook = function()
					require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
				end,
			},
		},
	},
	event = "InsertEnter",
	config = function()
		require("plugins.luasnip.base")
	end,
}
