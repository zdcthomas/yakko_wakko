return {
	{
		"stevearc/conform.nvim",
		event = { "BufWrite" },
		-- lazy = false,
		opts = {
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
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
				nix = { "alejandra" },
				-- yaml = { "yamlfmt" },
				org = { "injected" },
				markdown = { "injected" },
			},
		},
	},
	-- {
	-- 	"mhartington/formatter.nvim",
	-- 	-- Utilities for creating configurations
	-- 	cmd = { "FormatWrite", "Format" },
	-- 	dependencies = { "williamboman/mason.nvim" },
	-- 	-- init = function()
	-- 	-- 	vim.g.save_format = true
	-- 	-- 	vim.keymap.set("n", "<leader><leader>f", ":Format<CR>", { silent = true })
	-- 	--
	-- 	-- 	local formatter_group = vim.api.nvim_create_augroup("formatter_group", { clear = true })
	-- 	--
	-- 	-- 	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	-- 	-- 		group = formatter_group,
	-- 	-- 		pattern = "*",
	-- 	-- 		callback = function()
	-- 	-- 			if vim.g.format_on_save then
	-- 	-- 				vim.cmd("FormatWrite")
	-- 	-- 			end
	-- 	-- 		end,
	-- 	-- 		desc = "Format Buffer",
	-- 	-- 	})
	-- 	-- end,
	-- 	config = function()
	-- 		require("formatter").setup({
	-- 			-- Enable or disable logging
	-- 			logging = true,
	-- 			-- Set the log level
	-- 			log_level = vim.log.levels.WARN,
	-- 			-- All formatter configurations are opt-in
	-- 			filetype = {
	-- 				-- Formatter configurations for filetype "lua" go here
	-- 				-- and will be executed in order
	-- 				typescript = {
	-- 					require("formatter.filetypes.typescript").prettierd,
	-- 				},
	-- 				typescriptreact = {
	-- 					require("formatter.filetypes.typescriptreact").prettierd,
	-- 				},
	-- 				nix = { require("formatter.filetypes.nix").alejandra },
	-- 				yaml = {
	-- 					-- require("formatter.filetypes.yaml").yamlfmt,
	-- 					function()
	-- 						return {
	-- 							exe = "yamlfmt",
	-- 							args = {
	-- 								"-in",
	-- 								"-formatter retain_line_breaks=true",
	-- 							},
	-- 							stdin = true,
	-- 						}
	-- 					end,
	-- 				},
	-- 				-- elixir = {
	-- 				-- 	require("formatter.filetypes.elixir").mixformat,
	-- 				-- },
	-- 				sql = {
	-- 					{
	-- 						exe = "sql-formatter",
	-- 						-- args = { "-" },
	-- 						stdin = true,
	-- 					},
	-- 				},
	-- 				sh = {
	-- 					require("formatter.filetypes.sh").shfmt,
	-- 				},
	-- 				lua = {
	-- 					require("formatter.filetypes.lua").stylua,
	-- 				},
	-- 				markdown = {
	-- 					require("formatter.filetypes.markdown").prettierd,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
