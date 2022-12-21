return {
	"mhartington/formatter.nvim",
	-- Utilities for creating configurations
	cmd = { "FormatWrite", "Format" },
	dependencies = { "williamboman/mason.nvim" },
	init = function()
		vim.g.save_format = true
		vim.keymap.set("n", "<leader><leader>f", ":Format<CR>", { silent = true })

		local formatter_group = vim.api.nvim_create_augroup("formatter_group", { clear = true })

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = formatter_group,
			pattern = "*",
			callback = function()
				if vim.g.format_on_save then
					vim.cmd("FormatWrite")
				end
			end,
			desc = "Map q to close buffer",
		})
	end,
	config = function()
		require("config.formatter")
	end,
}
