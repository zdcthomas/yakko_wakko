return {
	{
		"stevearc/conform.nvim",
		event = { "BufWrite" },
		-- lazy = false,
		opts = {
			format_on_save = function()
				if not vim.g.format_on_save then
					return false
				end
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				-- python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				-- rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				-- typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				-- nix = { "alejandra" },
				-- yaml = { "yamlfmt" },
				org = { "injected" },
				markdown = { "injected" },
			},
		},
	},
}
