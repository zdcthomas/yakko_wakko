local Module = {}

local Hydra, hydra_loaded = pcall(require, "hydra")
if not hydra_loaded then
	vim.notify("Hydra not found in Telescope hydra config!", "Error")
	return
end

local function cmd(command)
	return "<CMD>" .. command .. "<CR>"
end

local cmd = require("hydra.keymap-util").cmd

local telescope_hint = [[
                 _p_: Files
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _b_: Buffers      _F_: Live Grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _c_: Colorschemes _/_: Search in File
  🭅█ ▁     █🭐   _g_: Git Status   _r_: Resume
  ██🬿      🭊██   _h_: Vim Help
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀                    _:_: Commands
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _R_: Registers    _?_: Search History

                 _<Enter>_: All Pickers        _<Esc>_
]]
Module.hydra = Hydra({
	name = "Telescope",
	hint = telescope_hint,
	config = {
		color = "teal",
		hint = {
			position = "middle",
			border = "rounded",
		},
	},
	mode = "n",
	heads = {
		{ "p", cmd("Telescope find_files") },
		{ "g", cmd("Telescope git_status") },
		{ "r", cmd("Telescope resume") },
		{ "F", cmd("Telescope live_grep") },
		{ "h", cmd("Telescope help_tags"), { desc = "Vim help" } },
		{ "b", cmd("Telescope oldfiles"), { desc = "Recently opened files" } },
		{ "H", cmd("Telescope highlights"), { desc = "Hightlights" } },
		{ "R", cmd("Telescope registers") },
		{ "c", cmd("Telescope colorscheme"), { desc = "Projects" } },
		{ "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "Search in file" } },
		{ "?", cmd("Telescope search_history"), { desc = "Search history" } },
		{ ":", cmd("Telescope commands"), { desc = "Command-line history" } },
		{ "<Enter>", cmd("Telescope"), { exit = true, desc = "List all pickers" } },
		{ "<Esc>", nil, { exit = true, nowait = true } },
	},
})

return Module
