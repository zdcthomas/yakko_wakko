local Module = {
	hint = [[
    EEEVERYTHING
  ]],
	g_hydras = {
		-- key = {
		--   key = "string",
		--   description = "string",
		--   hydra = a hyrda
		-- }
	},
}

Module.rebuild_hydra = function()
	local Hydra = require("hydra")
	local beeg_boi = {
		name = "EVERYTHING",
		hint = Module.hint,
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

		beeg_boi.hint = beeg_boi.hint .. "\n _" .. key .. "_ " .. (hydra.desc or "")
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

	Module.rebuild_hydra()
end

return Module
