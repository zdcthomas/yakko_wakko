local Module = {}

local shared = require("config.lspconfig.shared")
local common_on_attach = shared.common_on_attach
local capabilities = shared.capabilities()
local setup_dap_keybindings = shared.setup_dap_keybindings

local on_attach = function(client, bufnr)
	-- local rt = require("rust-tools")
	common_on_attach(client, bufnr)
	-- Hover actions
	-- vim.keymap.set("n", "gH", rt.hover_actions.hover_actions, { buffer = bufnr })
	-- Code action groups
	-- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
	setup_dap_keybindings(bufnr)
end

Module.setup = function()
	local path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")
	local rt = require("rust-tools")
	local opts = {
		hover_actions = {

			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = "rounded",

			-- whether the hover action window gets automatically focused
			-- default: false
			-- auto_focus = true,
		},
		server = {
			on_attach = on_attach,
		},
	}
	local codelldb_path = path .. "adapter/codelldb"
	local liblldb_path = path .. "lldb/lib/liblldb.so"

	if vim.fn.has("mac") == 1 then
		liblldb_path = path .. "lldb/lib/liblldb.dylib"
	end

	if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
		local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
		opts.dap = {
			adapter = adapter,
		}
	else
		vim.notify("please reinstall codellb, i cannot find liblldb or codelldb itself", vim.log.levels.WARN)
	end
	rt.setup(opts)

	require("rust-tools.dap").setup_adapter()

	local dap = require("dap")
	-- Pr(dap.configurations)
	dap.configurations.rust = dap.configurations.rt_lldb
end

return Module
