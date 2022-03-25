local function setup()
	local patterns = require("nrpattern.default")
	patterns['()x"(%x+)"'] = {
		base = 16, -- Hexadecimal
		format = '%sx"%s"', -- Output format
		priority = 15, -- Determines order in pattern matching
	}

	-- Add a cyclic pattern (toggles between yes and no)
	patterns[{ "yes", "no" }] = { priority = 5 }

	require("nrpattern").setup(patterns)
end

require("packer").use({
	"zegervdv/nrpattern.nvim",
	config = setup,
})
