local Module = {}

Module.setup = function(capabilities, common_on_attach)
	require("lspconfig")["tsserver"].setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
end

return Module
