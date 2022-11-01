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

-- local function dir_exists(f)
-- 	local ok, _, code = os.rename(f, f)
-- 	if not ok then
-- 		if code == 13 then
-- 			-- Permission denied, but it exists
-- 			return true
-- 		end
-- 	end
-- 	return ok
-- end

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
	vim.notify({ result.message }, lvl, {
		title = "LSP | " .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == "ERROR" or lvl == "WARN"
		end,
	})
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", close_events = { "CursorMoved", "BufHidden" } })

local function setup_rust_tools(common_on_attach)
	local rt = require("rust-tools")
	local path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")
	-- if not dir_exists(mason_path) then
	-- 	vim.notify("please install codelldb using :Mason", vim.log.levels.ERROR)
	-- end
	local opts = {
		hover_actions = {

			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			},

			-- whether the hover action window gets automatically focused
			-- default: false
			-- auto_focus = true,
		},
		dap = {
			-- adapter = {
			-- 	type = "executable",
			-- 	command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			-- 	port = 9222,
			-- 	name = "rt_lldb",
			-- 	args = { "--port", "9222" },
			-- },
		},
		server = {

			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)
				-- Hover actions
				vim.keymap.set("n", "gH", rt.hover_actions.hover_actions, { buffer = bufnr })
				-- Code action groups
				vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

				vim.keymap.set("n", "<Leader>B", require("dap").toggle_breakpoint)
				vim.keymap.set("n", "<Leader>dr", require("dap").repl.open)
				vim.keymap.set("n", "<Leader>dc", require("dap").continue)
				vim.keymap.set("n", "<Leader>dl", require("dap").step_into)
				vim.keymap.set("n", "<Leader>dh", require("dap").step_out)
			end,
		},
	}
	local codelldb_path = path .. "adapter/codelldb"
	local liblldb_path = path .. "lldb/lib/liblldb.so"

	if vim.fn.has("mac") == 1 then
		liblldb_path = path .. "lldb/lib/liblldb.dylib"
	end

	if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
		-- vim.notify("Found codelldb, setting opt")
		-- vim.notify(codelldb_path)
		-- vim.notify(liblldb_path)
		local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
		opts.dap = {
			adapter = adapter,
		}
	else
		vim.notify("please reinstall codellb, i cannot find liblldb or codelldb itself", vim.log.levels.WARN)
	end
	rt.setup(opts)

	require("rust-tools.dap").setup_adapter()
end

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

	setup_rust_tools(common_on_attach)
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
