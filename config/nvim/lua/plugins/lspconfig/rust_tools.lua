local Module = {}
Module.dap_adapter = function()
	local extension_path = vim.env.RUST_DAP

	if extension_path then
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb"
		local this_os = vim.loop.os_uname().sysname
		liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
		return require("rust-tools.dap").get_codelldb_adapter(vim.fn.expand(codelldb_path), vim.fn.expand(liblldb_path))
	end
end

Module.setup = function(capabilities, common_on_attach)
	local opts = {

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
		},
		server = {
			capabilities = capabilities,
			standalone = true,
			settings = {
				["rust-analyzer"] = {
					typing = {
						autoClosingAngleBrackets = {
							enable = true,
						},
					},
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
	}

	local adapter = Module.dap_adapter()
	if adapter then
		opts.dap = {
			adapter = adapter,
		}
	end

	require("rust-tools").setup(opts)
end

return Module
