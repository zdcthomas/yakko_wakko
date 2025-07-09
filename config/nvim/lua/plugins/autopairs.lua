return {
	{
		"windwp/nvim-autopairs",

		event = "InsertEnter",

		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				fast_wrap = {},
				check_ts = true,
				disable_in_macro = true,
			})

			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			autopairs.get_rules("{")[1] = nil
			autopairs.add_rules({
				Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+")):with_move(function(opts)
					return opts.char == ">"
				end),
			})
		end,
	},
}
