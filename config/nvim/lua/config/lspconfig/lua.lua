local Module = {}
local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

Module.setup = function()
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	require("neodev").setup({
		override = function(root_dir, library)
			if require("neodev.util").has_file(root_dir, "/etc/nixos") then
				library.enabled = true
				library.plugins = true
			end
		end,
	})

	-- then setup your lsp server as usual
	local lspconfig = require("lspconfig")

	-- example to setup sumneko and enable call snippets
	lspconfig.sumneko_lua.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
				},
				workspace = {
					checkThirdParty = false,
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
				telemetry = {
					enable = false,
				},

				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "hs" },
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end

return Module
