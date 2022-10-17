local Hydra = Pquire("hydra")
if not Hydra then
	return
end

local hint = [[
  ^ ^     EEEVVVEERRRYYYTHTNING
  ^
  _t_ Telescope
  _g_ Git Mode
  _w_ Windows
  _p_ Packer Managment
  _o_ Options
  _v_ Venn (drawin')
  ^
]]

local Module = {
	g_hydras = {
		-- key = {
		--   key = "string",
		--   description = "string",
		--   hydra = a hyrda
		-- }
	},
}
local function rebuild_hydra()
	local beeg_boi = {
		name = "EVERYTHING",
		hint = hint,
		config = {
			invoke_on_body = true,
			hint = {
				show_name = true,
				type = "window",
				position = "top-right",
				border = "double",
			},
		},
		mode = "n",
		body = "<Leader>;",
		heads = {
			{ "<Esc>", nil, { exit = true } },
		},
	}

	for key, hydra in pairs(Module.g_hydras) do
		table.insert(beeg_boi.heads, {
			hydra.key,
			function()
				hydra.hydra:activate()
			end,
			{ desc = hydra.desc or "", exit = true },
		})
	end

	Hydra(beeg_boi)
end

function Module.add_g_hydra(hyd)
	vim.validate({
		key = { hyd.key, "string" },
		description = { hyd.description, { "string", "nil" } },
		hydra = { hyd.hydra, "table" },
	})

	Module.g_hydras[hyd.key] = hyd

	rebuild_hydra()
end

local function side_scroll(Hydra)
	return Hydra({
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

Module.setup = function()
	require("config.hydra.hy_side_scroll")

	local window_h = require("config.hydra.hy_window")
	Module.add_g_hydra({ key = "w", hydra = window_h, desc = "Window managment" })

	local packer = require("config.hydra.hy_packer")
	Module.add_g_hydra({ key = "p", hydra = packer, desc = "Packer" })

	local options = require("config.hydra.hy_options")
	Module.add_g_hydra({ key = "o", hydra = options, desc = "Packer" })

	local venn = require("config.hydra.hy_venn")
	Module.add_g_hydra({ key = "v", hydra = venn, desc = "Venn" })
end

return Module
