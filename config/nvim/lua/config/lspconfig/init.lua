local conf = {}

function conf.lightbulb()
	require("nvim-lightbulb").update_lightbulb({
		sign = {
			enabled = false,
		},
		virtual_text = {
			enabled = true,
			-- Text to show at virtual text
			text = "💡",
			-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
			hl_mode = "combine",
		},
	})
end

-- I __think__ this is causing an error...
-- vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
-- 	local client = vim.lsp.get_client_by_id(ctx.client_id)
-- 	local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
-- 	vim.notify({ result.message }, lvl, {
-- 		title = "LSP | " .. client.name,
-- 		timeout = 10000,
-- 		keep = function()
-- 			return lvl == "ERROR" or lvl == "WARN"
-- 		end,
-- 	})
-- end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", close_events = { "CursorMoved", "BufHidden" } })

function conf.setup()
	-- local servers = {
	-- 	"rust_analyzer",
	-- 	"jsonls",
	-- 	"yamlls",
	-- 	"prosemd_lsp",
	-- 	"marksman",
	-- 	"rnix",
	-- 	"bashls",
	-- 	"elixirls",
	-- 	"sumneko_lua",
	-- 	"tsserver",
	-- 	"eslint",
	-- }

	require("mason-lspconfig").setup({
		-- ensure_installed = servers,
	})

	local common_on_attach = require("config.lspconfig.shared").common_on_attach
	local capabilities = require("config.lspconfig.shared").capabilities()
	local lspconfig = require("lspconfig")

	require("config.lspconfig.eslint").setup()
	require("config.lspconfig.typescript").setup()

	require("config.lspconfig.lua").setup()
	require("config.lspconfig.rust").setup()
	-- lspconfig["rust_analyzer"].setup({
	-- 	on_attach = common_on_attach,
	-- 	capabilities = capabilities,
	-- })

	lspconfig["jsonls"].setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig["yamlls"].setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig["rnix"].setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
	-- require("mason-lspconfig").setup_handlers({
	-- 	function(server_name) -- default handler (optional)
	-- 		-- vim.pretty_print(server_name)
	-- 		lspconfig[server_name].setup({
	-- 			on_attach = common_on_attach,
	-- 			capabilities = capabilities,
	-- 		})
	-- 	end,
	-- 	["sumneko_lua"] = function()
	-- 		require("config.lspconfig.lua").setup()
	-- 	end,
	-- 	["tsserver"] = function()
	-- 		require("config.lspconfig.typescript").setup()
	-- 	end,
	-- 	["eslint"] = function()
	-- 		require("config.lspconfig.eslint").setup()
	-- 	end,
	-- })
end

return conf
