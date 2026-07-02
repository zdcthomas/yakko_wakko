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
		"nvim-orgmode/telescope-orgmode.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-orgmode/orgmode",
		},
		keys = {
			{
				"<leader>or",
				function()
					require("telescope").extensions.orgmode.refile_heading()
				end,
				desc = "[o]rg [r]efile (fuzzy, works in capture/agenda too)",
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
				desc = "[o]rg [a]genda prompt",
			},
			{
				-- <leader>oA would be shadowed by orgmode's buffer-local
				-- org_toggle_archive_tag in org files, so use w for "week"
				"<leader>ow",
				function()
					require("orgmode").action("agenda.open_by_key", "d")
				end,
				desc = "[o]rg dashboard: [w]eek + inbox",
			},
			{
				"<leader>oi",
				function()
					vim.cmd.edit(vim.fn.expand(org_agenda_path("inbox.org")))
				end,
				desc = "[o]rg [i]nbox",
			},
		},
		opts = {

			org_agenda_files = { org_agenda_path("**/*.org"), wiki_path("writing/**/*.org") },
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
				-- week agenda only shows SCHEDULED/DEADLINE items, so the
				-- dashboard adds a block for the (unscheduled) inbox
				d = {
					description = "Dashboard: week + inbox",
					types = {
						{
							type = "agenda",
							org_agenda_overriding_header = "This week",
						},
						{
							type = "tags_todo",
							org_agenda_overriding_header = "Inbox — to process",
							org_agenda_files = { org_agenda_path("inbox.org") },
						},
					},
				},
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
					template = "* [[%?]]",
					headline = "Links",
				},
				t = {
					description = "Inbox (refile later)",
					template = { "* TODO %?", ":PROPERTIES:", ":CREATED: %U", ":END:" },
					target = org_agenda_path("inbox.org"),
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
							template = { "* %?", ":PROPERTIES:", ":HAPPENED: %U", ":END:" },
							target = org_agenda_path("work.org"),
						},
						t = {
							description = "todos",
							template = { "* TODO %?", ":PROPERTIES:", ":CREATED: %U", ":END:" },
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
							template = { "* %?", "%U" },
							properties = {
								empty_lines = 2,
							},
							headline = "Thoughts",
							target = wiki_path("writing/inbox.org"),
						},
						s = {
							description = "Story ideas",
							template = { "* %?", "%U" },
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
						-- %() is evaluated at capture time, so the target follows the
						-- current cwd instead of the cwd when the plugin first loaded
						t = {
							description = "todo",
							template = { "* TODO %?", ":PROPERTIES:", ":CREATED: %U", ":END:" },
							target = org_agenda_path("repos")
								.. "/%(return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')).org",
						},
						n = {
							description = "notes",
							template = { "* %? %u" },
							target = org_agenda_path("repos")
								.. "/%(return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')).org",
						},
					},
				},
			},
			mappings = {
				-- native refile prompts disabled in favor of the global <leader>or
				-- telescope refile, which works in org files, capture buffers, and agenda
				org = {
					org_do_demote = "<leader>>",
					org_do_promote = "<leader><",
					org_refile = false,
				},
				capture = {
					org_capture_refile = false,
				},
				agenda = {
					org_agenda_refile = false,
				},
			},
		},
	},
}
