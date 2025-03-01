return {
	{
		"chipsenkbeil/org-roam.nvim",
		ft = { "org" },
		dependencies = {
			{
				"nvim-orgmode/orgmode",
			},
		},
		config = function()
			require("org-roam").setup({
				directory = "~/Irulan/wiki/roam",
				-- optional
				-- org_files = {
				-- 	"~/Irulan/wiki/org",
				-- },
			})
		end,
	},
	{
		"nvim-orgmode/orgmode",
		ft = { "org" },
		keys = {
			{
				"<Space>oc",
				function()
					require("orgmode").action("capture.prompt")
				end,
			},
			{
				"<Space>oa",
				function()
					require("orgmode").action("agenda.prompt")
				end,
			},
		},
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_agenda_files = { "~/Irulan/wiki/**/*" },
				org_default_notes_file = "~/Irulan/wiki/refile.org",
				org_startup_folded = "showeverything",
				mappings = {
					org = {
						org_do_demote = "_",
						org_do_promote = "+",
					},
				},
			})

			-- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
			-- add ~org~ to ignore_install
			-- require('nvim-treesitter.configs').setup({
			--   ensure_installed = 'all',
			--   ignore_install = { 'org' },
			-- })
		end,
	},
}
