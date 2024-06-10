local Module = {}

Module.setup = function(capabilities, common_on_attach)
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	-- require("neodev").setup({
	-- 	library = { plugins = { "nvim-dap-ui" }, types = true },
	-- 	override = function(root_dir, library)
	-- 		if root_dir:find("/etc/nixos", 1, true) == 1 then
	-- 			library.enabled = true
	-- 			library.plugins = true
	-- 		end
	-- 	end,
	-- })

	-- then setup your lsp server as usual
	local lspconfig = require("lspconfig")

	-- example to setup sumneko and enable call snippets
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						-- "${3rd}/luv/library"
						-- "${3rd}/busted/library",
					},
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				},
			})
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
