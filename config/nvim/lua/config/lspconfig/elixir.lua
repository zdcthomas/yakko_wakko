local common_on_attach = require("config.lspconfig.shared").common_on_attach
local capabilities = require("config.lspconfig.shared").capabilities()

local Module = {}

local uv = vim.loop
local lsputil = require("lspconfig.util")

local get_cursor_position = function()
	local rowcol = vim.api.nvim_win_get_cursor(0)
	local row = rowcol[1] - 1
	local col = rowcol[2]

	return row, col
end

local function manipulate_pipes(direction, client)
	local row, col = get_cursor_position()

	client.request_sync("workspace/executeCommand", {
		command = "manipulatePipes:serverid",
		arguments = { direction, "file://" .. vim.api.nvim_buf_get_name(0), row, col },
	}, nil, 0)
end

local function from_pipe(client)
	return function()
		manipulate_pipes("fromPipe", client)
	end
end

local function to_pipe(client)
	return function()
		manipulate_pipes("toPipe", client)
	end
end

local function expand_macro(client)
	return function()
		local params = vim.lsp.util.make_given_range_params()

		local text = vim.api.nvim_buf_get_text(
			0,
			params.range.start.line,
			params.range.start.character,
			params.range["end"].line,
			params.range["end"].character,
			{}
		)

		local resp = client.request_sync("workspace/executeCommand", {
			command = "expandMacro:serverid",
			arguments = { params.textDocument.uri, vim.fn.join(text, "\n"), params.range.start.line },
		}, nil, 0)

		local content = {}
		if resp["result"] then
			for k, v in pairs(resp.result) do
				vim.list_extend(content, { "# " .. k, "" })
				vim.list_extend(content, vim.split(v, "\n"))
			end
		else
			table.insert(content, "Error")
		end

		-- not sure why i need this here
		vim.schedule(function()
			vim.lsp.util.open_floating_preview(vim.lsp.util.trim_empty_lines(content), "elixir", {})
		end)
	end
end

-- local nil_buf_id = 999999
-- local term_buf_id = nil_buf_id

--[[
-- Test runner for mix test
--]]
-- local function test(command)
-- 	local row, col = get_cursor_position()
-- 	local args = command.arguments[1]
-- 	local current_buf_id = vim.api.nvim_get_current_buf()

-- 	-- delete the current buffer if it's still open
-- 	if vim.api.nvim_buf_is_valid(term_buf_id) then
-- 		vim.api.nvim_buf_delete(term_buf_id, { force = true })
-- 		term_buf_id = nil_buf_id
-- 	end

-- 	vim.cmd("botright new | lua vim.api.nvim_win_set_height(0, 15)")
-- 	term_buf_id = vim.api.nvim_get_current_buf()
-- 	vim.opt_local.number = false
-- 	vim.opt_local.cursorline = false

-- 	local cmd = "mix test " .. args.filePath

-- 	-- add the line number if it's for a specific describe/test block
-- 	if args.describe or args.testName then
-- 		cmd = cmd .. ":" .. (row + 1)
-- 	end

-- 	vim.fn.termopen(cmd, {
-- 		on_exit = function(_jobid, exit_code, _event)
-- 			if exit_code == 0 then
-- 				vim.api.nvim_buf_delete(term_buf_id, { force = true })
-- 				term_buf_id = nil_buf_id
-- 				vim.notify("Success: " .. cmd, vim.log.levels.INFO)
-- 			else
-- 				vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
-- 			end
-- 		end,
-- 	})

-- 	vim.cmd([[wincmd p]])
-- end

-- local function settings(opts)
-- 	return {
-- 		elixirLS = vim.tbl_extend("force", {
-- 			dialyzerEnabled = true,
-- 			fetchDeps = false,
-- 			enableTestLenses = false,
-- 			suggestSpecs = false,
-- 		}, opts),
-- 	}
-- end

-- function command(params)
-- 	local install_path = Path:new(
-- 		params.path,
-- 		params.repo,
-- 		Utils.safe_path(params.ref),
-- 		params.versions,
-- 		"language_server.sh"
-- 	)

-- 	return install_path
-- end

-- local cache_dir = Path:new(vim.fn.getcwd(), ".elixir_ls", "elixir.nvim")
-- local download_dir = cache_dir:joinpath("downloads")
-- local install_dir = Path:new(vim.fn.expand("~/.cache/nvim/elixir.nvim/installs"))

-- local function install_elixir_ls(opts)
-- 	local source_path = Download.clone(tostring(download_dir:absolute()), opts)
-- 	local bufnr = M.open_floating_window()

-- 	local result = Compile.compile(
-- 		download_dir:joinpath(source_path):absolute(),
-- 		opts.install_path:absolute(),
-- 		vim.tbl_extend("force", opts, { bufnr = bufnr })
-- 	)
-- end

-- function M.setup(opts)
-- 	if not elixir_nvim_output_bufnr then
-- 		elixir_nvim_output_bufnr = vim.api.nvim_create_buf(false, true)
-- 		vim.api.nvim_buf_set_name(elixir_nvim_output_bufnr, "ElixirLS Output Panel")
-- 	end

-- 	opts = opts or {}
-- 	lspconfig.elixirls.setup(vim.tbl_extend("keep", {
-- 		-- on_init = lsputil.add_hook_after(default_config.on_init, function(client)
-- 		-- 	client.commands["elixir.lens.test.run"] = test
-- 		-- end),
-- 		on_new_config = function(new_config, new_root_dir)
-- 			new_opts = make_opts(opts)

-- 			local cmd = M.command({
-- 				path = tostring(install_dir),
-- 				repo = new_opts.repo,
-- 				ref = new_opts.ref,
-- 				versions = Version.get(),
-- 			})

-- 			if not cmd:exists() then
-- 				vim.ui.select({ "Yes", "No" }, { prompt = "Install ElixirLS" }, function(choice)
-- 					if choice == "Yes" then
-- 						install_elixir_ls(vim.tbl_extend("force", new_opts, { install_path = cmd:parent() }))
-- 					end
-- 				end)

-- 				return
-- 			else
-- 				local updated_config = new_config
-- 				updated_config.cmd = { tostring(cmd) }

-- 				return updated_config
-- 			end
-- 		end,
-- 		settings = opts.settings or settings,
-- 		capabilities = opts.capabilities or capabilities,
-- 		root_dir = opts.root_dir or root_dir,
-- 		on_attach = lsputil.add_hook_before(opts.on_attach, M.on_attach),
-- 	}, opts))
-- end

local root_dir = function(fname)
	local path = lsputil.path
	local child_or_root_path = lsputil.root_pattern({ "mix.exs", ".git" })(fname)
	local maybe_umbrella_path = lsputil.root_pattern({ "mix.exs" })(
		uv.fs_realpath(path.join({ child_or_root_path, ".." }))
	)

	local has_ancestral_mix_exs_path = vim.startswith(child_or_root_path, path.join({ maybe_umbrella_path, "apps" }))
	if maybe_umbrella_path and not has_ancestral_mix_exs_path then
		maybe_umbrella_path = nil
	end

	path = maybe_umbrella_path or child_or_root_path or vim.loop.os_homedir()

	return path
end
Module.setup = function()
	require("lspconfig")["elixirls"].setup({
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})
			vim.lsp.codelens.refresh()

			local add_user_cmd = vim.api.nvim_buf_create_user_command
			add_user_cmd(bufnr, "ElixirFromPipe", from_pipe(client), {})
			add_user_cmd(bufnr, "ElixirToPipe", to_pipe(client), {})

			common_on_attach(client, bufnr)
		end,

		settings = {
			elixirLS = {
				dialyzerEnabled = true,
				fetchDeps = false,
				enableTestLenses = true,
				suggestSpecs = true,
			},
		},
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
		root_dir = root_dir,
		on_init = function(client)
			client.notify("workspace/didChangeConfiguration")
			client.commands["elixir.lens.test.run"] = test
			-- return true
		end,
	})
end

return Module
