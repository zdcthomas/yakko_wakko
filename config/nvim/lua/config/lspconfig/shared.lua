local Module = {}

Module.lspconfig_augroup = vim.api.nvim_create_augroup("LspConfigAuGroup", { clear = false })

function Module.capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	capabilities.textDocument.codeAction = {
		dynamicRegistration = true,
		codeActionLiteralSupport = {
			codeActionKind = {
				valueSet = (function()
					local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
					table.sort(res)
					return res
				end)(),
			},
		},
	}

	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	local ok, lsp_status = pcall(require, "lsp-status")
	if ok then
		capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities) or capabilities
	end
	return capabilities
end

Module.common_on_attach = function(client, bufnr)
	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = Module.lspconfig_augroup })

	vim.api.nvim_create_autocmd(
		{ "CursorHold", "CursorHoldI" },
		{ callback = require("config.lspconfig").lightbulb, buffer = bufnr, group = Module.lspconfig_augroup }
	)

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set({ "i", "n" }, "<c-l>", vim.lsp.buf.signature_help)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
	require("config.telescope").lsp_bindings_for_buffer(bufnr)

	if client.server_capabilities.hoverProvider then
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	end

	if client.server_capabilities.renameProvider then
		vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
	end

	if client.server_capabilities.codeLensProvider then
		vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
		vim.api.nvim_create_autocmd(
			{ "BufEnter", "CursorHold", "InsertLeave" },
			{ buffer = bufnr, callback = vim.lsp.codelens.refresh, group = Module.lspconfig_augroup }
		)
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.keymap.set("n", "<leader>gq", vim.lsp.buf.formatting, opts)
		vim.api.nvim_create_autocmd(
			{ "BufWritePre" },
			{ buffer = bufnr, callback = vim.lsp.buf.formatting_sync, group = Module.lspconfig_augroup }
		)
	end

	-- require("lsp_signature").on_attach({
	-- 	bind = true,
	-- 	floating_window = true,
	-- 	hint_enable = false,
	-- 	zindex = 40,
	-- 	transparency = 40,
	-- 	toggle_key = "<C-x>",
	-- 	auto_close_after = 4,
	-- 	max_width = 60,
	-- 	handler_opts = {
	-- 		border = "double", -- double, rounded, single, shadow, none
	-- 	},
	-- })
end

return Module
