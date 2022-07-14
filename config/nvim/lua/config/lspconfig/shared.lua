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
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded" }
	)
	vim.api.nvim_create_autocmd(
		{ "CursorHold", "CursorHoldI" },
		{ callback = require("config.lspconfig").lightbulb, buffer = bufnr, group = Module.lspconfig_augroup }
	)

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
	require("config.telescope").lsp_bindings_for_buffer(bufnr)

	if client.resolved_capabilities.hover then
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	end

	if client.resolved_capabilities.rename then
		vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
	end

	if client.resolved_capabilities.code_lens then
		vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
		vim.api.nvim_create_autocmd(
			{ "BufEnter", "CursorHold", "InsertLeave" },
			{ buffer = bufnr, callback = vim.lsp.codelens.refresh, group = Module.lspconfig_augroup }
		)
	end

	if client.resolved_capabilities.document_formatting then
		vim.keymap.set("n", "<leader>gq", vim.lsp.buf.formatting, opts)
		vim.api.nvim_create_autocmd(
			{ "BufWritePre" },
			{ buffer = bufnr, callback = vim.lsp.buf.formatting_sync, group = Module.lspconfig_augroup }
		)
	end

	require("lsp_signature").on_attach({
		bind = true,
		zindex = 40,
		transparency = 40,
		auto_close_after = 4,
		max_width = 60,
		handler_opts = {
			border = "rounded", -- double, rounded, single, shadow, none
		},
	})
end

return Module
