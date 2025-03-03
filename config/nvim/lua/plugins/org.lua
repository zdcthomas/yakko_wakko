local wiki = "~/Irulan/wiki"
local wiki_path = function(path)
	return ("%s/%s"):format(wiki, path)
end
local org_agenda_path = function(path)
	local org_directory = wiki_path("agenda")
	return ("%s/%s"):format(org_directory, path)
end

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
				org_agenda_files = { wiki_path("**/*") },
				org_default_notes_file = org_agenda_path("/refile.org"),
				org_startup_folded = "content",
				org_capture_templates = {
					t = {
						description = "Refile",
						template = "* TODO %?\n",
					},
					w = {
						description = "Work",
						subtemplates = {
							n = {
								description = "notes",
								template = "* %?",
								target = org_agenda_path("work.org"),
							},
							t = {
								description = "todos",
								template = { "* TODO %?", " DEADLINE: %^{Deadline}T" },
								target = org_agenda_path("work.org"),
							},
						},
					},
					p = {
						description = "personal",
						subtemplates = {

							p = {
								description = "poetry",
								template = "* %?\n# %u",
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Poetry",
								target = wiki_path("writing/inbox.org"),
							},
							b = {
								description = "Bull",
								template = "* %?\n# %u",
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Thoughts",
								target = wiki_path("writing/inbox.org"),
							},
							s = {
								description = "Story ideas",
								template = "* %?\n# %u",
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Stories",
								target = wiki_path("writing/inbox.org"),
							},
							j = {
								description = "Journal",
								template = { "* %<%Y-%m-%d> %<%A>", "%?" },
								target = wiki_path("journal/%<%Y>/%<%m-%B>/%<%d>-%<%A>.org"),
							},
						},
					},
					r = {
						description = "per repo",
						subtemplates = {
							t = {
								description = "notes",
								template = "* TODO %?",
								target = [[ %(org_agenda_path(
									"repos/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".org"
								))]],
							},
							n = {
								desciption = "todo",
								template = "* %?",
								target = [[%(org_agenda_path(
                  "repos/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".org"
                ))]],
							},
						},
					},
				},
				mappings = {
					org = {
						org_do_demote = "_",
						org_do_promote = "+",
					},
				},
			})
		end,
	},
}
