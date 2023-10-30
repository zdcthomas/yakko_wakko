local Module = {}

Module.setup = function(capabilities, common_on_attach)
	require("lspconfig")["eslint"].setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		handlers = {
			["eslint/probeFailed"] = function()
				vim.notify("ESLint probe failed.", vim.log.levels.WARN)
				return {}
			end,
			["eslint/noLibrary"] = function()
				vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
				return {}
			end,
		},
	})
end

return Module
