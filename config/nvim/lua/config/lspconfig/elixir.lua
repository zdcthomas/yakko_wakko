local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

local Module = {}

Module.setup = function()
	require("lspconfig")["elixirls"].setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
		root_dir = require("lspconfig.util").root_pattern(".git"),
		on_init = function(client)
			client.notify("workspace/didChangeConfiguration")
			return true
		end,
	})
end

return Module
