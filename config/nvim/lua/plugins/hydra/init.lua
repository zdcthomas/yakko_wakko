return {

	"anuvyklack/hydra.nvim",
	dependencies = {
		"folke/zen-mode.nvim",
		"jbyuki/venn.nvim",
	},
	keys = { "z", "<Leader>;" },
	config = function()
		local Hydra = require("hydra")
		local cmd = require("hydra.keymap-util").cmd

		Hydra({
			name = "Side scroll",
			mode = "n",
			body = "z",
			heads = {
				{ "h", "5zh" },
				{ "l", "5zl", { desc = "←/→" } },
				{ "H", "zH" },
				{ "L", "zL", { desc = "half screen ←/→" } },
			},
		})

		local windows = require("plugins.hydra.windows")
		local options = require("plugins.hydra.options")
		local venn = require("plugins.hydra.venn")
		local glob_hyd = require("plugins.hydra.global_hydra")

		glob_hyd.add_g_hydra({ key = "w", hydra = windows, desc = "Window managment" })
		glob_hyd.add_g_hydra({ key = "o", hydra = options, desc = "Options" })
		glob_hyd.add_g_hydra({ key = "v", hydra = venn, desc = "Draw diagrams" })

		local lsp = Hydra({
			hint = [[
        ^ ^        LSP
        ^
        _o_ symbol Outline
        ^
            ^^^^                _<Esc>_
      ]],
			name = "Lsp",
			mode = "n",
			config = {
				invoke_on_body = true,
				hint = {
					border = "rounded",
					position = "top-right",
				},
			},
			heads = {
				{ "o", ":SymbolsOutline<cr>", { exit = true, silent = true, desc = "symbol outline" } },
				{ "<Esc>", nil, { exit = true } },
			},
		})

		glob_hyd.add_g_hydra({ key = "l", hydra = lsp, desc = "LSP" })
	end,
}
