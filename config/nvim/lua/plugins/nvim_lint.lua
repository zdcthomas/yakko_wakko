return {
	"mfussenegger/nvim-lint",
	dependencies = {
		"williamboman/mason.nvim",
	},
	init = function()
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
	config = function()
		require("lint").linters_by_ft = {
			sh = { "shellcheck" },
			nix = { "nix" },
		}
	end,
}
