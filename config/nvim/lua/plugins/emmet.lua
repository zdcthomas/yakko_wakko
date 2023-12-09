return {
	{
		"mattn/emmet-vim",
		ft = { "html", "heex", "js", "ts", "tsx", "typescriptreact" },
		config = function()
			vim.g.user_emmet_mode = "a"
		end,
	},
}
