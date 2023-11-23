local Module = {
	hint = [[
    EEEVERYTHING
  ]],
	-- body = "<leader>;",
	g_hydras = {
		-- key = {
		--   key = "string",
		--   description = "string",
		--   hydra = a hyrda
		-- }
	},
	new_gs = true,
}

Module.rebuild_hydra = function()
	if not Module.new_gs then
		return
	end
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
				border = "rounded",
			},
		},
		mode = "n",
		-- body = Module.body,
		heads = {
			{ "<Esc>", nil, { exit = true } },
		},
	}

	for key, hydra in pairs(Module.g_hydras) do
		table.insert(beeg_boi.heads, {
			hydra.key,
			function()
				Hydra(hydra.hydra):activate()
				-- hydra.hydra:activate()
			end,
			{ desc = hydra.desc or "", exit = true },
		})

		beeg_boi.hint = beeg_boi.hint .. "\n _" .. key .. "_ " .. (hydra.desc or "")
	end

	Module.main = Hydra(beeg_boi)
	Module.new_gs = false
end

function Module.add_g_hydra(hyd)
	vim.validate({
		key = { hyd.key, "string" },
		description = { hyd.description, { "string", "nil" } },
		hydra = { hyd.hydra, "table" },
	})

	Module.g_hydras[hyd.key] = hyd
	Module.new_gs = true
end

function Module.run()
	if not Module.main then
		Module.rebuild_hydra()
	end
	if Module.new_gs then
		Module.rebuild_hydra()
		Module.new_gs = false
	end

	Module.main:activate()
end

return Module
