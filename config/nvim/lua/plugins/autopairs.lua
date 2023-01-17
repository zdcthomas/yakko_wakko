return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			fast_wrap = {},
			check_ts = true,
			disable_in_macro = true,
		})

		-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		-- local cmp_status_ok, cmp = pcall(require, "cmp")
		-- if not cmp_status_ok then
		-- 	return
		-- end
		-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
