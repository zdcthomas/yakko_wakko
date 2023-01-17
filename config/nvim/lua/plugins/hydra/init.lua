return {
	"anuvyklack/hydra.nvim",
	dependencies = {
		"folke/zen-mode.nvim",
		"jbyuki/venn.nvim",
	},
	keys = { "z", "<Leader>;" },
	config = function()
		local Hydra = require("hydra")

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
	end,
}
