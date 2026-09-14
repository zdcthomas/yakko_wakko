local wiki = "~/Irulan/wiki"
local wiki_path = function(path)
	return ("%s/%s"):format(wiki, path)
end
local function org_agenda_path(path)
	local org_directory = wiki_path("agenda")
	return ("%s/%s"):format(org_directory, path)
end

-- today's daily-500-words entry, created with front matter on first access.
-- global because capture targets' %() strings are evaluated by orgmode
-- outside this file's closure
_G.OrgToday500Words = function()
	local dir = vim.fn.expand(wiki_path("writing/500-words"))
	local date = os.date("%Y-%m-%d")
	local path = ("%s/%s.org"):format(dir, date)
	if vim.fn.filereadable(path) == 0 then
		vim.fn.mkdir(dir, "p")
		vim.fn.writefile({
			"#+TITLE: " .. date,
			"#+DATE: <" .. date .. ">",
			"#+EDITED: no",
			"",
		}, path)
	end
	return path
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

			-- Workarounds for an upstream bug: refile_heading runs the refile
			-- while the picker is still open. orgmode's hidden edit window then
			-- steals focus, telescope tears down the prompt, and the refile ends
			-- with "Invalid window id" (reported as a false "Refile failed")
			-- followed by a crash in the adapter's close of the dead picker.

			-- 1. close the picker before refiling (standard telescope ordering)
			local lib_actions = require("telescope-orgmode.lib.actions")
			local execute_refile = lib_actions.execute_refile
			lib_actions.execute_refile = function(...)
				local t_actions = require("telescope.actions")
				local prompt_bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[prompt_bufnr].filetype == "TelescopePrompt" then
					t_actions.close(prompt_bufnr)
				end
				-- 2. guard the adapter's follow-up close of the now-dead picker;
				-- registered here because every new picker clears replacements
				local t_state = require("telescope.actions.state")
				t_actions.close:replace_if(function(bufnr)
					return t_state.get_current_picker(bufnr) == nil
				end, function() end)
				return execute_refile(...)
			end

			-- 3. orgmode's edit_file() helper ends by restoring focus to the
			-- window that was current when the refile started (the capture
			-- float or picker prompt), which may be gone by then; tolerate it
			local utils = require("orgmode.utils")
			local edit_file = utils.edit_file
			utils.edit_file = function(...)
				local handle = edit_file(...)
				local close = handle.close
				handle.close = function(...)
					local ok, err = pcall(close, ...)
					if not ok and not tostring(err):match("Invalid window id") then
						error(err)
					end
				end
				return handle
			end
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
			{
				"<leader>o5",
				function()
					vim.cmd.edit(_G.OrgToday500Words())
				end,
				desc = "[o]rg today's [5]00 words",
			},
			{
				-- inbox processing: move the heading under the cursor into a
				-- brand new agenda file (e.g. work/traddle) created on the spot
				"<leader>of",
				function()
					local api = require("orgmode.api")
					local ok, current = pcall(api.current)
					local source = ok and current:get_closest_headline() or nil
					if not source then
						vim.notify("No org heading under cursor", vim.log.levels.WARN)
						return
					end
					vim.ui.input({ prompt = "New agenda file (e.g. work/traddle): " }, function(input)
						if not input or vim.trim(input) == "" then
							return
						end
						local name = vim.trim(input):gsub("%.org$", "")
						local path = vim.fn.expand(org_agenda_path(name .. ".org"))
						if vim.fn.filereadable(path) == 0 then
							vim.fn.mkdir(vim.fs.dirname(path), "p")
							vim.fn.writefile({ "#+TITLE: " .. vim.fn.fnamemodify(path, ":t:r"), "" }, path)
						end
						api.refile({ source = source, destination = api.load(path) })
					end)
				end,
				desc = "[o]rg re[f]ile to new [f]ile",
			},
			{
				-- poems, posts, and projects are whole files, not headings, so
				-- "capture" for them creates the file and opens it for editing
				"<leader>on",
				function()
					local kinds = {
						{ label = "Work project", dir = "work", skeleton = { "* Notes", "", "* Tasks" } },
						{
							label = "Personal project",
							dir = "personal/projects",
							skeleton = { "* Notes", "", "* Tasks" },
						},
						{ label = "Blog post", dir = "personal/blog" },
						{ label = "Poem", dir = "personal/poetry" },
					}
					vim.ui.select(kinds, {
						prompt = "New org file",
						format_item = function(kind)
							return kind.label
						end,
					}, function(kind)
						if not kind then
							return
						end
						vim.ui.input({ prompt = kind.label .. " name: " }, function(input)
							if not input or vim.trim(input) == "" then
								return
							end
							local title = vim.trim(input):gsub("%.org$", "")
							local slug = title:lower():gsub("%s+", "-")
							local path = vim.fn.expand(org_agenda_path(("%s/%s.org"):format(kind.dir, slug)))
							if vim.fn.filereadable(path) == 0 then
								vim.fn.mkdir(vim.fs.dirname(path), "p")
								local lines = { "#+TITLE: " .. title, "#+CATEGORY: " .. slug, "" }
								vim.list_extend(lines, kind.skeleton or {})
								vim.fn.writefile(lines, path)
							end
							vim.cmd.edit(path)
						end)
					end)
				end,
				desc = "[o]rg [n]ew project/poem/post file",
			},
			{
				"<leader>oo",
				function()
					require("telescope.builtin").find_files({
						prompt_title = "Org files",
						search_dirs = {
							vim.fn.expand(wiki_path("agenda")),
							vim.fn.expand(wiki_path("writing")),
						},
					})
				end,
				desc = "[o]rg [o]pen file",
			},
			{
				"<leader>os",
				function()
					local root = vim.fn.expand("~/Irulan")
					local function git(args, on_ok)
						vim.system(vim.list_extend({ "git", "-C", root }, args), { text = true }, function(out)
							if out.code ~= 0 then
								vim.schedule(function()
									local detail = vim.trim((out.stderr or "") .. (out.stdout or ""))
									vim.notify(
										("Irulan git %s failed:\n%s"):format(args[1], detail),
										vim.log.levels.ERROR
									)
								end)
								return
							end
							on_ok(out)
						end)
					end
					-- commit what's on screen, not just what's on disk
					vim.cmd("silent! wall")
					git({ "add", "-A" }, function()
						git({ "status", "--porcelain" }, function(status)
							local function push()
								git({ "push" }, function()
									vim.schedule(function()
										vim.notify("Irulan synced")
									end)
								end)
							end
							if status.stdout == "" then
								-- nothing new to commit; push anyway in case an
								-- earlier commit never made it out
								push()
							else
								git({ "commit", "-m", os.date("%Y-%m-%d") }, push)
							end
						end)
					end)
				end,
				desc = "[o]rg [s]ync: commit + push Irulan",
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
				t = {
					description = "Inbox (refile later)",
					template = { "* TODO %?", ":PROPERTIES:", ":CREATED: %U", ":END:" },
					target = org_agenda_path("inbox.org"),
				},
				p = {
					description = "Personal thought",
					template = { "* %?", "%U" },
					properties = {
						empty_lines = 1,
					},
					target = org_agenda_path("personal/thoughts.org"),
				},
				j = {
					description = "Journal",
					template = { "%?" },
					datetree = { reversed = true, tree_type = "day" },
					target = wiki_path("writing/journal.org"),
				},
				w = {
					description = "Daily 500 Words",
					template = { "%?" },
					target = "%(return OrgToday500Words())",
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
