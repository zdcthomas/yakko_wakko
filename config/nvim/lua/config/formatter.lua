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
		yaml = {
			require("formatter.filetypes.yaml").yamlfmt,
		},
		elixir = {
			require("formatter.filetypes.elixir").mixformat,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
	},
})

