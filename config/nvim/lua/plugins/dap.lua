local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
			"theHamsta/nvim-dap-virtual-text",
			-- "rcarriga/nvim-dap-ui",
			{ "igorlfs/nvim-dap-view", opts = {} },
			{
				"nvim-telescope/telescope-dap.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
				},
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
		},
		init = function()
			local hint = [[
		        ^ ^Step^ ^ ^      ^ ^     Action
		    ----^-^-^-^--^-^----  ^-^-------------------
		        ^ ^back^ ^ ^     ^_t_: toggle breakpoint
		        ^ ^ ^ ^^ ^        _T_: clear breakpoints
		    out _H_ ^ ^ _L_ into  _c_: continue
		        ^ ^ _J_ ^ ^       _x_: terminate
		        ^ ^over ^ ^     ^^_r_: run last 
		                     ^^^^^_R_: Restart
		                     ^^^^^_K_: Hover

		        ^ ^  _q_: exit
		    ]]

			local hydra = {
				name = "Debug",
				hint = hint,
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						type = "window",
						float_opts = {
							border = "double",
						},
						position = "top-right",
					},
				},
				mode = { "n" },
				body = "<leader>d,",
				heads = {
					{
						"H",
						function()
							require("dap").step_out()
						end,
						{ desc = "step out" },
					},
					{
						"R",
						function()
							require("dap").restart()
						end,
						{ desc = "Restart" },
					},
					{
						"J",
						function()
							require("dap").step_over()
						end,
						{ desc = "step over" },
					},
					-- {
					-- 	"K",
					-- 	function()
					-- 		require("dap").step_back()
					-- 	end,
					-- 	{ desc = "step back" },
					-- },
					{
						"L",
						function()
							require("dap").step_into()
						end,
						{ desc = "step into" },
					},
					{
						"t",
						function()
							require("dap").toggle_breakpoint()
						end,
						{ desc = "toggle breakpoint" },
					},
					{
						"T",
						function()
							require("dap").clear_breakpoints()
						end,
						{ desc = "clear breakpoints" },
					},
					{
						"c",
						function()
							require("dap").continue()
						end,
						{ desc = "continue" },
					},
					{
						"x",
						function()
							require("dap").terminate()
						end,
						{ desc = "terminate" },
					},
					{
						"K",
						function()
							require("dap.ui.widgets").hover()
						end,
						desc = "Hover",
					},
					{
						"r",
						function()
							require("dap").run_last()
						end,
						{ exit = true, desc = "run last dap entry" },
					},
					{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
				},
			}

			local glob_hyd = require("plugins.hydra.global_hydra")
			glob_hyd.add_g_hydra({ key = "d", hydra = hydra, desc = "Debugger" })
		end,
		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to line (no execute)",
			},
			{
				"<leader>dl",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").step_over()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").step_back()
				end,
				desc = "Up",
			},
			{
				"<leader>dR",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dh",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dK",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Hover",
			},
		},
		config = function()
			-- TODO: <14-11-23, zdcthomas> when I'm not busy, make this lua
			vim.cmd([[
        autocmd FileType dap-float nnoremap <buffer><silent> q <cmd>close!<CR>
      ]])
			local dap = require("dap")

			local extension_path = vim.env.JS_DAP
			require("dap").adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = extension_path, -- "js-debug-adapter"
					args = { "${port}" },
				},
			}
			for _, language in ipairs({ "typescript", "javascript" }) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to node",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
							"${file}",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						port = 8123,
					},
				}
			end
			dap.adapters.godot = {
				type = "server",
				host = "127.0.0.1",
				port = 6006,
			}
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}", --let both ports be the same for now...
				executable = {
					command = "js-debug",
					args = { "${port}" },
				},
			}
			dap.configurations.gdscript = {
				{
					type = "godot",
					request = "launch",
					name = "Launch scene",
					project = "${workspaceFolder}",
					launch_scene = true,
				},
			}
			-- dap.adapters.rust = require("plugins.lspconfig.rust_tools").dap_adapter()
			dap.configurations.rust = {
				{
					-- If you get an "Operation not permitted" error using this, try disabling YAMA:
					--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
					name = "Attach to process",
					type = "rust", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
					request = "attach",
					pid = require("dap.utils").pick_process,
					args = {},
				},
			}
			local dv = require("dap-view")
			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close()
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close()
			end
		end,
	},
	{
		"leoluz/nvim-dap-go",
		ft = { "go" },
		config = function()
			require("dap-go").setup({
				-- Additional dap configurations can be added.
				-- dap_configurations accepts a list of tables where each entry
				-- represents a dap configuration. For more details do:
				-- :help dap-configuration
				dap_configurations = {
					{
						-- Must be "go" or it will be ignored by the plugin
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				-- delve configurations
				delve = {
					-- the path to the executable dlv which will be used for debugging.
					-- by default, this is the "dlv" executable on your PATH.
					path = "dlv",
					-- time to wait for delve to initialize the debug session.
					-- default to 20 seconds
					initialize_timeout_sec = 20,
					-- a string that defines the port to start delve debugger.
					-- default to string "${port}" which instructs nvim-dap
					-- to start the process in a random available port
					port = "${port}",
					-- additional args to pass to dlv
					args = {},
					-- the build flags that are passed to delve.
					-- defaults to empty string, but can be used to provide flags
					-- such as "-tags=unit" to make sure the test suite is
					-- compiled during debugging, for example.
					-- passing build flags using args is ineffective, as those are
					-- ignored by delve in dap mode.
					build_flags = "",
				},
			})
		end,
	},
}
