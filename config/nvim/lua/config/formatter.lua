vim.g.save_format = true
vim.keymap.set("n", "<leader><leader>f", ":Format<CR>", { silent = true })
local util = require("formatter.util")

-- Provides the Format and FormatWrite commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		typescript = {
			require("formatter.filetypes.typescript").prettierd,
		},
		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettierd,
		},

		elixir = {
			require("formatter.filetypes.elixir").mixformat,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
	},
})

local formatter_group = vim.api.nvim_create_augroup("formatter_group", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = formatter_group,
	pattern = "*",
	callback = function()
		if vim.g.save_format then
			vim.cmd("FormatWrite")
		end
	end,
	desc = "Map q to close buffer",
})