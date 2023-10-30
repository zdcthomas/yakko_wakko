local Module = {}

Module.setup = function(capabilities, common_on_attach)
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	require("neodev").setup({
		library = { plugins = { "nvim-dap-ui" }, types = true },
		override = function(root_dir, library)
			if root_dir:find("/etc/nixos", 1, true) == 1 then
				library.enabled = true
				library.plugins = true
			end
		end,
	})

	-- then setup your lsp server as usual
	local lspconfig = require("lspconfig")

	-- example to setup sumneko and enable call snippets
	lspconfig.lua_ls.setup({
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
					-- Get the language server to recognize the `vim` and `hs` (hammerspoon) global
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
