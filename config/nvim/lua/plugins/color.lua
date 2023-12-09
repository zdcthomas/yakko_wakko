return {
	{
		"uga-rosa/ccc.nvim",
		ft = {
			"lua",
			"nix",
			"heex",
			"html",
			"rust",
			"css",
			"js",
			"ts",
			"jsx",
			"tsx",
		},
		cmd = {
			"CccPick",
			"CccConvert",
			"CccHighlighterToggle",
			"CccHighlighterEnable",
			"CccHighlighterDisable",
		},
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
				excludes = { "lazy", "mason", "help", "neo-tree" },
			},
		},
	},
}
