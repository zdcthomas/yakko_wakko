local Module = {}
local function keybindings_setup(keybinds)
	keybinds.remap("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")
	keybinds.map_event_to_mode("norg", {
		n = {
			{ "<C-s>", "core.integrations.telescope.find_linkable" },
		},
		i = {
			{ "<C-l>", "core.integrations.telescope.insert_file_link" },
		},
	}, {
		silent = true,
		noremap = true,
	})
end

Module.setup = function()
	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.norg.qol.toc"] = {},
			["core.norg.concealer"] = {},
			["core.integrations.telescope"] = {},
			["core.integrations.nvim-cmp"] = {},
			["core.gtd.base"] = {
				config = {
					workspace = "wiki",
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
					workspaces = {
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

	---@diagnostic disable-next-line: missing-parameter
	neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
		keybinds.map_to_mode("norg", {
			n = {
				{ "<C-k>", "core.norg.manoeuvre.move_item_up" },
				{ "<C-j>", "core.norg.manoeuvre.move_item_down" },
			},
		})

		keybinds.map_event_to_mode("norg", {
			n = {
				{ "<Leader>fp", "core.integrations.telescope.find_linkable" },
			},
			i = {
				{ "<C-l>", "core.integrations.telescope.insert_link" },
				{ "<C-f>", "core.integrations.telescope.insert_file_link" },
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
end

return Module
