local augroup = vim.api.nvim_create_augroup("LspFormattingNull", {})
local null = require("null-ls")
null.setup({
	sources = {
		-- null.builtins.formatting.stylua,
		null.builtins.diagnostics.eslint,
		null.builtins.code_actions.statix,
		-- null.builtins.formatting.prettierd.with({
		-- 	filetypes = {
		-- 		"javascript",
		-- 		"javascriptreact",
		-- 		"typescript",
		-- 		"typescriptreact",
		-- 		"vue",
		-- 		"css",
		-- 		"scss",
		-- 		"less",
		-- 		"html",
		-- 		"graphql",
		-- 	},
		-- }),
	},
	-- on_attach = function(client, bufnr)
	-- 	if client.supports_method("textDocument/formatting") then
	-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			group = augroup,
	-- 			buffer = bufnr,
	-- 			callback = function()
	-- 				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
	-- 				vim.lsp.buf.formatting_sync()
	-- 			end,
	-- 		})
	-- 	end
	-- end,
})
