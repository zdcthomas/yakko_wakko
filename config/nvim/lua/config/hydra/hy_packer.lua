local Hydra = Pquire("hydra")
if not Hydra then
	return
end

return Hydra({
	name = "Packer",
	mode = "n",
	config = {
		color = "blue",
	},
	heads = {
		{ "s", ":PackerSync" },
		{ "c", ":PackerCompile" },
		{ "u", ":PackerUpdate" },
		{ "S", ":PackerStatus" },

		{ "<ESC>", nil, { nowait = true } },
	},
})
