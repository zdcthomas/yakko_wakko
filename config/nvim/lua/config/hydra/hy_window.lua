local Hydra = Pquire("hydra")
if not Hydra then
	return vim.notify("hydra not available", "ERROR")
end

local window_hint = [[
 ^^^^^^     Move     ^^^^^^   ^^   Split   ^^   ^ ^    Other
 ^^^^^^--------------^^^^^^   ^^-----------^^   ^-^------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^    ^   _<c-k>_   ^   _z_: Zen
 _h_ ^ ^ _l_   _H_ ^ ^ _L_    _<c-h>_ _<c-l>_   _o_: Only-ify
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^    ^   _<c-j>_   ^   _q_: Close
 focus^^^^^^   window^^^^^^   ^_=_: equalize^   _w_: Save
]]

return Hydra({
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
	-- body = "<leader><leader>w",
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

		{ "o", "<c-w>o" },
		{ "=", "<c-w>=" },

		{ "w", ":w<cr>" },
		{ "q", ":q<cr>" },
		{ "z", ":ZenMode<cr>", { nowait = true, exit = true } },
		{ "<ESC>", nil, { exit = true, nowait = true } },
	},
})
