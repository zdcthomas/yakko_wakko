local wiki = "~/Irulan/wiki"
local date_string = "%<%Y%m%d%H%M%S>"
local wiki_path = function(path)
	return ("%s/%s"):format(wiki, path)
end
local function org_agenda_path(path)
	local org_directory = wiki_path("agenda")
	return ("%s/%s"):format(org_directory, path)
end

return {

	{
		"nvim-orgmode/telescope-orgmode.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-orgmode/orgmode",
		},
		keys = {
			{
				"<leader>tOr",
				function()
					require("telescope").extensions.orgmode.refile_heading()
				end,
				desc = "[t]elescope [o]rg [r]efile",
			},
			{
				"<leader>tOh",
				function()
					require("telescope").extensions.orgmode.search_headings()
				end,
				desc = "[t]elescope [o]rg [h]eadings",
			},
			{
				"<leader>tOl",
				function()
					require("telescope").extensions.orgmode.insert_link()
				end,
				desc = "[t]elescope [o]rg insert [l]ink",
			},
		},
		config = function()
			require("telescope").load_extension("orgmode")
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		dependencies = {
			"nvim-orgmode/orgmode",
		},
		opts = {
			database = {
				update_on_save = true,
			},
			bindings = {
				prefix = "<leader>r",
			},
			directory = "~/Irulan/wiki/roam",
			-- templates = {
			-- 	l = {
			-- 		description = "link",
			-- 		template = { "- [[%?]]", "* " },
			-- 		target = "link-%[slug].org",
			-- 	},
			-- 	t = {
			-- 		description = "thought",
			-- 		template = { "* %?" },
			-- 	},
			-- },
			org_files = {
				org_agenda_path("/personal.org"),
			},
			extensions = {
				dailies = {
					bindings = false,
				},
			},
		},
		-- event = { "VeryLazy" },
		keys = { { "<leader>rc", desc = "roam capture" }, { "<leader>rf", desc = "roam find" } },
	},
	{
		"nvim-orgmode/orgmode",
		ft = { "org" },
		keys = {
			{
				"<leader>oc",
				function()
					require("orgmode").action("capture.prompt")
				end,
				desc = "[o]rg [c]apture",
			},
			{
				"<leader>oa",
				function()
					require("orgmode").action("agenda.prompt")
				end,
				desc = "[o]rg [a]genda",
			},
		},
		opts = {

			org_agenda_files = { org_agenda_path("**/*"), wiki_path("writing/**/*") },
			org_default_notes_file = org_agenda_path("/personal.org"),
			org_agenda_skip_deadline_if_done = true,
			org_startup_folded = "content",
			org_id_link_to_org_use_id = true,
			org_adapt_indentation = false,
			org_todo_keywords = {
				"TODO(t)",
				"QUESTION(q)",
				"EDIT(e)",
				"|",
				"DONE(d)",
				"DELEGATED(D)",
				"ABANDONED(a)",
				"ANSWERED(A)",
			},
			org_log_done = "note",
			org_log_into_drawer = "LOGBOOK",
			org_todo_keyword_faces = {
				EDIT = ":foreground green :weight bold",
				QUESTION = ":foreground green :weight bold",
			},
			org_agenda_custom_commands = {
				w = {
					description = "Writing to edit",
					types = {
						{
							type = "tags_todo",
							org_agenda_overriding_header = "Personal projects agenda",
							org_agenda_files = { wiki_path("writing/inbox.org") },
						},
					},
				},
			},
			org_capture_templates = {
				l = {
					description = "Links",
					template = {
						"* ",
						"[[%?]]",
					},
					healine = "Links",
				},
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
						a = {
							description = "accomplishments",
							headline = "Accomplishments",
							template = { "* %?", "HAPPENED: %u" },
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
								empty_lines = 1,
							},
							headline = "Poetry",
							target = wiki_path("writing/inbox.org"),
						},
						b = {
							description = "Bull",
							template = { "* %?", "# %u" },
							properties = {
								empty_lines = 2,
							},
							headline = "Thoughts",
							target = wiki_path("writing/inbox.org"),
						},
						s = {
							description = "Story ideas",
							template = { "* %?", "# %u" },
							properties = {
								empty_lines = 2,
							},
							headline = "Stories",
							target = wiki_path("writing/inbox.org"),
						},
						j = {
							description = "Journal",
							template = { "%?" },
							datetree = { reversed = true, tree_type = "day" },
							target = wiki_path("writing/journal.org"),
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
					org_do_demote = "<leader>>",
					org_do_promote = "<leader><",
				},
			},
		},
	},
}
