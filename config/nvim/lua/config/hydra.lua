local Module = {}

local function cmd(command)
	return "<CMD>" .. command .. "<CR>"
end

-- ^ is zero space in hints
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

local function open_or_move(direction)
	local current_window = vim.fn.winnr()
	vim.api.nvim_exec("wincmd " .. direction, false)

	if current_window == vim.api.nvim_eval("winnr()") then
		if vim.tbl_contains({ "j", "k" }, direction) then
			vim.api.nvim_exec("wincmd s", false)
		else
			vim.api.nvim_exec("wincmd v", false)
		end

		vim.api.nvim_exec("wincmd " .. direction, false)
	end
end

local window_hint = [[
 ^^^^^^     Move     ^^^^^^   ^^   Split   ^^   ^ ^    Other
 ^^^^^^--------------^^^^^^   ^^-----------^^   ^-^------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^    ^   _<c-k>_   ^   _n_: New Window
 _h_ ^ ^ _l_   _H_ ^ ^ _L_    _<c-h>_ _<c-l>_   _o_: Only-ify
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^    ^   _<c-j>_   ^   _q_: Close
 focus^^^^^^   window^^^^^^   ^_=_: equalize^   _w_: Save
]]

local function side_scroll(Hydra)
	Hydra({
		name = "Side scroll",
		mode = "n",
		body = "z",
		heads = {
			{ "h", "5zh" },
			{ "l", "5zl", { desc = "←/→" } },
			{ "H", "zH" },
			{ "L", "zL", { desc = "half screen ←/→" } },
		},
	})
end

local function windows(Hydra)
	Hydra({
		config = {
			hint = {
				border = "rounded",
				position = "bottom",
			},
			color = "pink",
			invoke_on_body = true,
		},
		hint = window_hint,
		name = "windows n stuff",
		mode = "n",
		body = "<leader><leader>w",
		heads = {
			{ "L", "<c-w>L" },
			{ "J", "<c-w>J" },
			{ "K", "<c-w>K" },
			{ "H", "<c-w>H" },

			{ "l", "<c-w>l" },
			{ "j", "<c-w>j" },
			{ "k", "<c-w>k" },
			{ "h", "<c-w>h" },

			{ "<c-j>", ":rightbelow sp<CR>" },
			{ "<c-l>", ":rightbelow vsp<CR>" },

			{ "<c-k>", ":leftabove sp<CR>" },
			{ "<c-h>", ":leftabove vsp<CR>" },

			{ "n", ":vnew<CR>" },
			{ "o", "<c-w>o" },
			{ "=", "<c-w>=" },

			{ "w", ":w<cr>" },
			{ "q", ":q<cr>" },
			{ "<ESC>", nil, { exit = true, nowait = true } },
		},
	})
end

local function telescope(Hydra)
	Hydra({
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
		body = "<Leader>f",
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
end

Module.setup = function()
	local Hydra = require("hydra")
	side_scroll(Hydra)
	windows(Hydra)
	telescope(Hydra)
end

return Module