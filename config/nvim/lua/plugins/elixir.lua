return {
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local elixir = require("elixir")
			local elixirls = require("elixir.elixirls")

			local common_on_attach = require("plugins.lspconfig.shared").common_on_attach

			elixir.setup({
				nextls = {
					enable = true, -- defaults to false
					-- port = 9000, -- connect via TCP with the given port. mutually exclusive with `cmd`. defaults to nil
					cmd = "nextls", -- path to the executable. mutually exclusive with `port`
					init_options = {
						-- mix_env = "test",
						-- mix_target = "host",
						experimental = {
							completions = {
								enable = true, -- control if completions are enabled. defaults to false
							},
						},
					},
					on_attach = function(client, bufnr)
						require("plugins.lspconfig.shared").common_on_attach(client, bufnr)
					end,
				},
				credo = {
					enable = false,
				},
				elixirls = {
					enable = false,
					settings = elixirls.settings({
						dialyzerEnabled = false,
						enableTestLenses = false,
					}),
					on_attach = function(client, bufnr)
						vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
						vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
						vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
						common_on_attach(client, bufnr)
					end,
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}
