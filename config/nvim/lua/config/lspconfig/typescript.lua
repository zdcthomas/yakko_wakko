local Module = {}

local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

Module.setup = function()
  require("lspconfig")["tsserver"].setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      common_on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  })
end

return Module
