return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			fast_wrap = {},
			check_ts = true,
			disable_in_macro = true,
		})

		local Rule = require("nvim-autopairs.rule")
		local npairs = require("nvim-autopairs")
		local cond = require("nvim-autopairs.conds")

		npairs.add_rules({
			Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+")):with_move(function(opts)
				return opts.char == ">"
			end),
		})

		-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		-- local cmp_status_ok, cmp = pcall(require, "cmp")
		-- if not cmp_status_ok then
		-- 	return
		-- end
		-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
