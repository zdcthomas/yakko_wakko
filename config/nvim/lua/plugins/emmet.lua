return {
	{
		"mattn/emmet-vim",
		ft = { "html", "heex", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		config = function()
			vim.g.user_emmet_mode = "a"
		end,
	},
}
