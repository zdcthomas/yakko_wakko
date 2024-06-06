return {

	"nvimtools/hydra.nvim",
	-- dependencies = {
	-- 	"folke/zen-mode.nvim",
	-- },
	keys = { "z", {
		"<Leader>;",
		function()
			require("plugins.hydra.global_hydra").run()
		end,
	} },
	config = function()
		require("hydra").setup({
			hint = {
				float_opts = {
					border = "double",
				},
			},
		})
		local Hydra = require("hydra")
		-- local cmd = require("hydra.keymap-util").cmd

		Hydra({
			name = "Side scroll",
			mode = "n",
			body = "z",
			heads = {
				{ "h", "5zh" },
				{ "l", "5zl", { desc = "←/→" } },
				{ "H", "zH" },
				{ "L", "zL", { desc = "half screen ←/→" } },
			},
		})
		-- local dap = require("dap")
		-- local hint = [[
		--         ^ ^Step^ ^ ^      ^ ^     Action
		--     ----^-^-^-^--^-^----  ^-^-------------------
		--         ^ ^back^ ^ ^     ^_t_: toggle breakpoint
		--         ^ ^ _K_^ ^        _T_: clear breakpoints
		--     out _H_ ^ ^ _L_ into  _c_: continue
		--         ^ ^ _J_ ^ ^       _x_: terminate
		--         ^ ^over ^ ^     ^^_r_: open repl
		--
		--         ^ ^  _q_: exit
		--     ]]

		-- require("hydra")({
		-- 	name = "Debug",
		-- 	hint = hint,
		-- 	config = {
		-- 		color = "pink",
		-- 		invoke_on_body = true,
		-- 		hint = {
		-- 			type = "window",
		-- 			border = "rounded",
		-- 			position = "top-right",
		-- 		},
		-- 	},
		-- 	mode = { "n" },
		-- 	body = "<leader>d,",
		-- 	heads = {
		-- 		{ "H", dap.step_out, { desc = "step out" } },
		-- 		{ "J", dap.step_over, { desc = "step over" } },
		-- 		{ "K", dap.step_back, { desc = "step back" } },
		-- 		{ "L", dap.step_into, { desc = "step into" } },
		-- 		{ "t", dap.toggle_breakpoint, { desc = "toggle breakpoint" } },
		-- 		{ "T", dap.clear_breakpoints, { desc = "clear breakpoints" } },
		-- 		{ "c", dap.continue, { desc = "continue" } },
		-- 		{ "x", dap.terminate, { desc = "terminate" } },
		-- 		{ "r", dap.repl.open, { exit = true, desc = "open repl" } },
		-- 		{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
		-- 	},
		-- })

		local windows = require("plugins.hydra.windows")
		local options = require("plugins.hydra.options")
		-- local venn = require("plugins.hydra.venn")
		local glob_hyd = require("plugins.hydra.global_hydra")

		vim.print("hello")
		glob_hyd.add_g_hydra({ key = "w", hydra = windows, desc = "Window managment" })
		glob_hyd.add_g_hydra({ key = "o", hydra = options, desc = "Options" })
		-- glob_hyd.add_g_hydra({ key = "v", hydra = venn, desc = "Draw diagrams" })

		local lsp = {
			hint = [[
        ^ ^        LSP
        ^
        _n_ NavBuddy! zoom
        _e_ Errors (in qf)
        _r_ References
        ^
            ^^^^                _<Esc>_
      ]],
			name = "Lsp",
			mode = "n",
			config = {
				invoke_on_body = true,
				hint = {
					position = "top-right",
				},
			},
			heads = {
				-- { "o", ":SymbolsOutline<cr>", { exit = true, silent = true, desc = "symbol outline" } },
				{ "n", ":Navbuddy<cr>", { exit = true, silent = true, desc = "symbol outline" } },
				{
					"e",
					function()
						vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
					end,
					{ exit = true, silent = true, desc = "symbol outline" },
				},
				{ "r", vim.lsp.buf.references, { exit = true, silent = true, desc = "symbol outline" } },
				{ "<Esc>", nil, { exit = true } },
			},
		}

		glob_hyd.add_g_hydra({ key = "l", hydra = lsp, desc = "LSP" })
	end,
}
