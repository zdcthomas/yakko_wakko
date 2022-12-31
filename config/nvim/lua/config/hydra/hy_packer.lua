local  succ, Hydra = pcall(require, "hydra")
if not succ then
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
