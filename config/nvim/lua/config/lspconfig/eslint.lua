local Module = {}

local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

Module.setup = function()
  local config = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      common_on_attach(client, bufnr)
      -- vim.api.nvim_create_augroup("eslint", { clear = true })
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      -- 	buffer = bufnr,
      -- 	-- pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
      -- callback = function()
      -- vim.cmd("EslintFixAll")
      -- end,
      -- })
    end,
    capabilities = capabilities,
    -- settings = {
    -- 	format = true, -- this will enable formatting
    -- },
    handlers = {
      ["eslint/probeFailed"] = function()
        vim.notify("ESLint probe failed.", vim.log.levels.WARN)
        --return { id = nil, result = true }
        return {}
      end,
      ["eslint/noLibrary"] = function()
        vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
        return {}
        -- return { id = nil, result = true }
      end,
    },
    -- cmd = vim.list_extend({ "yarn", "node" }, {}),
  }
  require("lspconfig")["eslint"].setup(config)
end

return Module
