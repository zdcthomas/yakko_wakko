local wiki = "~/Irulan/wiki"
local wiki_path = function(path)
	return ("%s/%s"):format(wiki, path)
end
local function org_agenda_path(path)
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
				org_default_notes_file = org_agenda_path("/personal.org"),
				org_startup_folded = "content",
				org_adapt_indentation = false,
				org_todo_keywords = { "TODO", "EDIT(e)", "|", "DONE(d)", "DELEGATED(D)", "ABANDONED(a)" },
				org_log_done = "note",
				org_log_into_drawer = "LOGBOOK",
				org_todo_keyword_faces = {
					EDIT = ":foreground green :weight bold",
					-- DELEGATED = ":background #FFFFFF :slant italic :underline on",
				},
				org_capture_templates = {
					t = {
						description = "Refile",
						template = { "* TODO %?", "SCHEDULED: %u" },
						headline = "Todos",
					},
					i = {
						description = "Idea",
						headline = "Ideas",
						template = "* %?",
					},
					w = {
						description = "Work",
						subtemplates = {
							n = {
								description = "notes",
								headline = "Notes",
								template = "* %?",
								target = org_agenda_path("work.org"),
							},
							t = {
								description = "todos",
								template = { "* TODO %?", "SCHEDULED: %u" },
								headline = "Tasks",
								target = org_agenda_path("work.org"),
							},
							-- T = {
							-- 	description = "todos",
							-- 	headline = "Tasks",
							-- 	template = { "* TODO %?", "SCHEDULED: %u DEADLINE: %^{Deadline}T" },
							-- 	target = org_agenda_path("work.org"),
							-- },
						},
					},
					p = {
						description = "personal",
						subtemplates = {
							p = {
								description = "poetry",
								template = "* %? %u",
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Poetry",
								target = wiki_path("writing/inbox.org"),
							},
							b = {
								description = "Bull",
								template = { "* %?", "# %u" },
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Thoughts",
								target = wiki_path("writing/inbox.org"),
							},
							s = {
								description = "Story ideas",
								template = { "* %?", "# %u" },
								properties = {
									edits = 0,
									like = false,
								},
								headline = "Stories",
								target = wiki_path("writing/inbox.org"),
							},
							j = {
								description = "Journal",
								template = { "* %?" },
								datetree = { reversed = true, tree_type = "day" },
								target = wiki_path("journal.org"),
							},
						},
					},
					r = {
						description = "per repo",
						subtemplates = {
							t = {
								description = "todo",
								template = {
									"* TODO %?",
									"- Captured on %u",
								},
								target = org_agenda_path("repos")
									.. "/"
									.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
									.. ".org",
							},
							n = {
								desciption = "notes",
								template = { "* %? %u" },
								target = org_agenda_path("repos")
									.. "/"
									.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
									.. ".org",
							},
						},
					},
				},
				mappings = {
					org = {
						org_do_demote = "<leader><",
						org_do_promote = "<leader>>",
					},
				},
			})
		end,
	},
}
