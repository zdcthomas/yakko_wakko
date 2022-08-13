local Module = {}

local Hydra = Pquire("Hydra")
if not Hydra then
	vim.notify("Hydra not found in Telescope hydra config!", "Error")
	return
end

local function cmd(command)
	return "<CMD>" .. command .. "<CR>"
end

local telescope_hint = [[
                 _p_: Files        _m_: Marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _b_: Buffers      _F_: Live Grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _C_: Colorschemes _/_: Search in File
  🭅█ ▁     █🭐
  ██🬿      🭊██   _h_: Vim Help     _c_: Execute Command
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _k_: Keymap       _;_: Commands History
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _r_: Registers    _?_: Search History

                 _<Enter>_: Telescope           _<Esc>_ 
]]
Module.hydra = Hydra({
	name = "Telescope",
	hint = telescope_hint,
	config = {
		color = "teal",
		invoke_on_body = true,
		hint = {
			position = "middle",
			border = "rounded",
		},
	},
	mode = "n",
	heads = {
		{ "p", cmd("Telescope find_files") },
		{ "F", cmd("Telescope live_grep") },
		{ "h", cmd("Telescope help_tags"), { desc = "Vim help" } },
		{ "b", cmd("Telescope oldfiles"), { desc = "Recently opened files" } },
		{ "m", cmd("MarksListBuf"), { desc = "Marks" } },
		{ "k", cmd("Telescope keymaps") },
		{ "r", cmd("Telescope registers") },
		{ "C", cmd("Telescope colorscheme"), { desc = "Projects" } },
		{ "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "Search in file" } },
		{ "?", cmd("Telescope search_history"), { desc = "Search history" } },
		{ ";", cmd("Telescope command_history"), { desc = "Command-line history" } },
		{ "c", cmd("Telescope commands"), { desc = "Execute command" } },
		{ "<Enter>", cmd("Telescope"), { exit = true, desc = "List all pickers" } },
		{ "<Esc>", nil, { exit = true, nowait = true } },
	},
})

return Module
