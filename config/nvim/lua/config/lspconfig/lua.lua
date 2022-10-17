local Module = {}
local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

Module.setup = function()
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	--local config = {
	--	on_attach = function(client, bufnr)
	--		-- I'm a little upset at the lack of trailing commas in the sumneko bundled formatter
	--		-- client.server_capabilities.documentFormattingProvider = false
	--		-- client.server_capabilities.documentRangeFormattingProvider = false
	--		-- client.resolved_capabilities.document_formatting = false
	--		-- client.server_capabilities.document_formatting = false

	--		client.server_capabilities.documentFormattingProvider = false
	--		--
	--		common_on_attach(client, bufnr)
	--		-- Stylua has been fucking up hard
	--		-- vim.api.nvim_create_autocmd("BufWritePre", {
	--		-- 	buffer = bufnr,
	--		-- 	group = lspconfig_augroup,
	--		-- 	callback = function() require("stylua-nvim").format_file({ error_display_strategy = "none" })
	--		-- 	end,
	--		-- })
	--		--
	--	end,
	--	init_options = { documentFormatting = true },
	--	capabilities = capabilities,
	--	flags = {
	--		debounce_text_changes = 150,
	--	},
	--	settings = {
	--		Lua = {
	--			-- runtime = {
	--			-- 	-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	--			-- 	version = "LuaJIT",
	--			-- 	-- Setup your lua path
	--			-- 	path = runtime_path,
	--			-- },
	--			diagnostics = {
	--				-- Get the language server to recognize the `vim` global
	--				globals = { "vim" },
	--			},
	--			workspace = {
	--				-- Make the server aware of Neovim runtime files
	--				library = {
	--					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
	--					[vim.fn.stdpath("config") .. "/lua"] = true,
	--				},
	--			},
	--			-- Do not send telemetry data containing a randomized but unique identifier
	--			telemetry = {
	--				enable = false,
	--			},
	--		},
	--	},
	--}
	-- local lua_dev = pcall(require, "lua-dev")
	-- if lua_dev then
	-- 	config = require("lua-dev").setup({ lspconfig = config })
	-- end

	-- require("lspconfig")["sumneko_lua"].setup(config)

	require("neodev").setup({
		-- add any options here, or leave empty to use the default settings
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
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	})
end

return Module
