local Module = {}

Module.setup = function(capabilities, common_on_attach)
	require("rust-tools").setup({
		tools = {
			autoSetHints = false,
			inlay_hints = {
				auto = false,
			},
			hover_actions = {
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				auto_focus = false,
			},
			runnables = {
				use_telescope = true,
			},
			dap = {
				adapter = {
					type = "executable",
					command = "lldb-vscode",
					name = "rt_lldb",
				},
			},
		},
		server = {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					procMacro = {
						enable = true,
					},
					checkOnSave = {
						command = "clippy",
					},
					diagnostics = {
						experimental = { enable = true },
					},
					files = {
						excludeDirs = { "./relay-ui" },
					},
				},
			},
			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)
				local rt = require("rust-tools")
				vim.keymap.set("n", "gh", rt.hover_actions.hover_actions, { buffer = bufnr })
				vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
			end,
		},
	})
end

return Module
