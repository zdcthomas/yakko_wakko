local conf = {}
local startify = "startify"
local dashboard = "dashboard"
local mini = "mini"
local starter = dashboard

local function center(list)
	return vim.fn["startify#center"](list)
end

local running_man = [[
	  \                           /      
	   \                         /       
	    \                       /        
	     ]                     [    '|  
	     ]               &&&&  [   /  |  
	     ]___           &&&&&&_[ '   |  
	     ]  ]\          &&&/[  [ |:   |  
	     ]  ] \          &/ [  [ |:   |  
	     ]  ]  ]         [  [  [ |:   |  
	     ]  ]  ]__     __[  [  [ |:   |  
	     ]  ]  ] ]\ _ /[ [  [  [ |:   |  
	     ]  ]  ] ] (#) [ [  [  [ :===='  
	     ]  ]  ]_].nHn.[_[  [  [         
	     ]  ]  ]  HHHHH. [  [  [         
	     ]  ] /   `HH("N  \ [  [         
	     ]__]/     HHH  "  \[__[         
	     ]         NNN         [         
	     ]         N/"         [         
	     ]         N H         [         
	    /          N            \        
	   /           q            \       
	  /                           \      
	]]

local function pick_header(hour_of_day)
	return require("sprout").pick({ hour = hour_of_day, default = running_man })
end

return {
	{
		"echasnovski/mini.starter",
		version = false,
		cond = starter == mini,
		lazy = false,
		opts = function()
			local starter = require("mini.starter")

			return {
				-- Whether to open starter buffer on VimEnter. Not opened if Neovim was
				-- started with intent to show something else.
				autoopen = true,

				-- Whether to evaluate action of single active item
				evaluate_single = true,

				-- Items to be displayed. Should be an array with the following elements:
				-- - Item: table with <action>, <name>, and <section> keys.
				-- - Function: should return one of these three categories.
				-- - Array: elements of these three types (i.e. item, array, function).
				-- If `nil` (default), default items will be used (see |mini.starter|).
				items = {
					{
						{
							action = "enew",
							name = "Edit new buffer",
							section = "めいれい",
						},
						{
							action = "Lazy",
							name = "Lazy",
							section = "めいれい",
						},
						{
							action = function()
								require("orgmode").action("capture.prompt")
							end,
							name = "Journal",
							section = "めいれい",
						},
						{
							action = "qall",
							name = "Quit Neovim",
							section = "めいれい",
						},
					},
					-- starter.sections.telescope(),
					starter.sections.recent_files(9, true),
				},

				-- Header to be displayed before items. Converted to single string via
				-- `tostring` (use `\n` to display several lines). If function, it is
				-- evaluated first. If `nil` (default), polite greeting will be used.
				header = pick_header(vim.fn.strftime("%H")),

				-- Footer to be displayed after items. Converted to single string via
				-- `tostring` (use `\n` to display several lines). If function, it is
				-- evaluated first. If `nil` (default), default usage help will be shown.
				footer = "",

				-- Array  of functions to be applied consecutively to initial content.
				-- Each function should take and return content for 'Starter' buffer (see
				-- |mini.starter| and |MiniStarter.content| for more details).
				content_hooks = {
					starter.gen_hook.adding_bullet("|> "),
					starter.gen_hook.aligning("center", "center"),
					starter.gen_hook.indexing("all", { "めいれい" }),
				},

				-- Characters to update query. Each character will have special buffer
				-- mapping overriding your global ones. Be careful to not add `:` as it
				-- allows you to go into command mode.
				query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",

				-- Whether to disable showing non-error feedback
				silent = true,
			}
		end,
	},
	{
		"glepnir/dashboard-nvim",
		cond = starter == dashboard,
		lazy = false,
		opts = function()
			-- plain file scan (no orgmode load), so cheap enough to run at startup
			local ok, org_stats = pcall(require, "utils.org_stats")
			local stats = ok and org_stats.collect() or { inbox = {}, due = {} }
			local function counted(desc, n)
				return n > 0 and ("%s (%d)"):format(desc, n) or desc
			end

			local opts = {
				theme = "doom",
				shortcut_type = "number",
				disable_move = false,
				hide = {
					-- statusline = false,
					tabline = false,
					-- winbar = false,
				},
				config = {
					vertical_center = true,
					-- week_header = {
					-- 	enable = true, --boolean use a week header
					-- 	-- concat  --concat string after time string line
					-- 	-- append  --table append after time string line
					-- },
					header = vim.split(pick_header(vim.fn.strftime("%H")), "\n"),
	         -- stylua: ignore
					center = {
	             { action = ":!dmux",                                                   desc = " Dmux",         desc_hl = "String", icon = " ", key = "d", },
	             { action = " Telescope oldfiles only_cwd=true",                        desc = " Recent files", desc_hl = "String", icon = " ", key = "o", },
	             { action = function() require("orgmode").action("capture.prompt") end, desc = " Capture",      desc_hl = "String", icon = " ", key = "c", },
	             { action = function() require("orgmode").action("agenda.open_by_key", "d") end, desc = counted(" Week + inbox", #stats.due), desc_hl = "String", icon = " ", key = "a", },
	             { action = "edit ~/Irulan/wiki/agenda/inbox.org",                       desc = counted(" Inbox", #stats.inbox), desc_hl = "String", icon = " ", key = "i", },
	             { action = ":Lazy",                                                    desc = " Lazy",         desc_hl = "String", icon = " ", key = "l", },
	             { action = ":q!",                                                      desc = " Quit",         desc_hl = "String", icon = " ", key = "q", },
	             { action = ":enew",                                                    desc = " Empty Buffer", desc_hl = "String", icon = "[]", key = "e", },
					},
					footer = function()
						local lazy_stats = require("lazy").stats()
						local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
						local lines = {
							"⚡ Neovim loaded "
								.. lazy_stats.loaded
								.. "/"
								.. lazy_stats.count
								.. " plugins in "
								.. ms
								.. "ms",
						}
						if ok then
							vim.list_extend(lines, org_stats.footer_lines(stats))
						end
						return lines
					end,
				},
			}

			return opts
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"mhinz/vim-startify",
		cond = starter == startify,
		branch = "center",
		lazy = false,
		config = function()
			vim.g.startify_center = 58
			vim.g.startify_commands = {
				{ l = { "Lazy", ":Lazy" } },
				{ d = { "Open dotfiles", ":!dmux ~/yakko_wakko" } },
				{ D = { "Dmux", ":!dmux" } },
				{
					t = {
						"Journal",
						function()
							require("orgmode").action("capture.prompt")
						end,
					},
				},
			}

			vim.g.startify_lists = {
				{ type = "commands", header = center({ "めいれい" }) },
				{ type = "dir", header = center({ "MRU " .. vim.fn.getcwd() }) },
			}

			vim.g.sttartify_change_to_dir = 0
			vim.g.startify_change_to_vcs_root = 1
			local ascii = pick_header(vim.fn.strftime("%H"))
			vim.g.startify_custom_header = center(ascii)

			-- local startify_group = vim.api.nvim_create_augroup("startify", { clear = true })
			-- vim.api.nvim_create_autocmd({ "User" }, {
			-- 	group = startify_group,
			-- 	pattern = "StartifyReady",
			-- 	callback = function()
			-- 		vim.keymap.set("n", "-", function()
			-- 			vim.cmd("bwipe")
			-- 			vim.cmd("Dirvish")
			-- 		end, { silent = true, buffer = true })
			-- 	end,
			-- })
		end,
	},
}
