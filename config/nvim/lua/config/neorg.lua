local Module = {}
local function keybindings_setup(keybinds)
	keybinds.map_event_to_mode("norg", {
		n = {
			{ "<C-s>", "core.integrations.telescope.find_linkable" },
			-- { "<C-s>", "core.integrations.telescope.find_linkable" },
		},
		i = {
			{ "<C-l>", "core.integrations.telescope.insert_link" },
		},
	}, {
		silent = true,
		noremap = true,
	})
end
local function start_neorg()
	if not require("neorg").is_loaded() then
		vim.cmd("NeorgStart silent=true")
	end
end

local function gtd_views()
	start_neorg()
	vim.cmd("Neorg gtd views")
end

local function gtd_capture()
	start_neorg()
	vim.cmd("Neorg gtd captue")
end

local function today()
	start_neorg()
	vim.cmd("Neorg journal today")
end

local function tomorrow()
	start_neorg()
	vim.cmd("Neorg journal tomorrow")
end

local function yesterday()
	start_neorg()
	vim.cmd("Neorg journal yesterday")
end

local function make_hydra()
	local Hydra = Pquire("hydra")
	if Hydra then
		local gtd_hydra = Hydra({
			name = "Getting Things Done!",
			mode = "n",
			heads = {
				{ "j", today },
				{ "t", tomorrow },
				{ "y", yesterday },
			},
		})

		local journal_hydra = Hydra({
			name = "Journalin'",
			mode = "n",
			heads = {
				{ "v", gtd_views },
				{ "c", gtd_views },
			},
		})

		local neorg_hyrda = Hydra({
			config = {
				color = "blue",
				invoke_on_body = true,
			},
			mode = "n",
			heads = {
				{
					"j",
					function()
						journal_hydra:activate()
					end,
				},
				{
					"g",
					function()
						gtd_hydra:activate()
					end,
				},
			},
		})

		require("config.hydra").add_g_hydra({ key = "n", hydra = neorg_hyrda, desc = "Neorg!" })
	end
end

Module.setup = function()
	make_hydra()

	vim.keymap.set("n", "<leader>ntv", gtd_views)

	vim.keymap.set("n", "<leader>ntn", function()
		if not require("neorg").is_loaded() then
			vim.cmd("NeorgStart silent=true")
		end
		vim.cmd("Neorg gtd capture")
	end)

	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.norg.concealer"] = {
				config = {
					folds = false,
				},
			},
			["core.integrations.telescope"] = {},
			["core.integrations.nvim-cmp"] = {},
			["core.export"] = {},
			["core.tangle"] = {},
			["core.export.markdown"] = {
				config = {
					extensions = "all",
				},
			},
			["core.presenter"] = {
				config = { -- Note that this table is optional and doesn't need to be provided
					zen_mode = "zen-mode",
				},
			},
			["core.gtd.base"] = {
				config = {
					workspace = "gtd",
				},
			},
			["core.norg.esupports.metagen"] = {
				config = {
					template = {
						{
							"title",
							function()
								return vim.fn.expand("%:p:t:r")
							end,
						},
						{ "description", "" },
						{ "authors", "Zachary Thomas" },
						{ "categories", "" },
						{
							"created",
							function()
								return os.date("%Y-%m-%d")
							end,
						},
						{ "version", require("neorg.config").version },
					},
				},
			},
			["core.keybinds"] = {
				config = { -- Note that this table is optional and doesn't need to be provided
					neorg_leader = vim.g.mapleader,
					hook = keybindings_setup,
				},
			},
			["core.norg.journal"] = {
				config = {
					strategy = "flat",
				},
			},
			["core.norg.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
			["core.norg.dirman"] = {
				config = {
					open_last_workspace = false,
					autochdir = false,
					default_workspace = "wiki",
					workspaces = {
						gtd = "~/irulan/gtd",
						wiki = "~/irulan",
					},
				},
			},
		},
	})

	local neorg_callbacks = require("neorg.callbacks")

	---@diagnostic disable-next-line: missing-parameter
	neorg_callbacks.on_event("core.autocommands.events.bufenter", function(event, event_content)
		-- local log = require('neorg.external.log')
		vim.opt_local.foldenable = false
		-- log.warn("Entered a neorg buffer!")
	end)

	-- TODO: Change this event to when entering an actual norg file
	---@diagnostic disable-next-line: missing-parameter
	neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
		--TODO:  In here, put bindings to capture/view gtd
		keybinds.map_event_to_mode("norg", {
			n = {
				{ "<Leader>fp", "core.integrations.telescope.find_linkable" },
				{ "<Leader>gv", "core.gtd.base.views" },
				{ "<Leader>ge", "core.gtd.base.edit" },
				{ "<Leader>gn", "core.gtd.base.capture" },
			},
			i = {
				-- { "<C-,>", "core.integrations.telescope.insert_link" },
				{ "<C-l>", "core.integrations.telescope.insert_link" },
			},
		}, {
			silent = true,
			noremap = true,
		})
	end)

	---@diagnostic disable-next-line: missing-parameter
	neorg_callbacks.on_event("core.autocommands.events.bufenter", function(_, _)
		vim.opt.spell.setlocal = true
	end)

	local neorg_group = vim.api.nvim_create_augroup("Zeorg", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = neorg_group,
		pattern = { "norg" },
		callback = function()
			vim.opt_local.spell = true
		end,
	})
end

return Module
