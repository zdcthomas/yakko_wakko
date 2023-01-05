return {
	"chrisgrieser/nvim-various-textobjs",
	init = function()
		vim.keymap.set({ "o", "x" }, "an", function()
			require("various-textobjs").number(false)
		end)
		vim.keymap.set({ "o", "x" }, "in", function()
			require("various-textobjs").number(true)
		end)

		-- exception: indentation textobj requires two parameters, first for exclusion of the
		-- starting border, second for the exclusion of ending border
		vim.keymap.set({ "o", "x" }, "ii", function()
			require("various-textobjs").indentation(true, true)
		end)
		vim.keymap.set({ "o", "x" }, "ai", function()
			require("various-textobjs").indentation(false, true)
		end)
		vim.keymap.set({ "o", "x" }, "aI", function()
			require("various-textobjs").indentation(false, false)
		end)

		vim.keymap.set({ "o", "x" }, "iv", function()
			require("various-textobjs").subword(true)
		end)
		vim.keymap.set({ "o", "x" }, "av", function()
			require("various-textobjs").subword(false)
		end)

		vim.keymap.set({ "o", "x" }, "iV", function()
			require("various-textobjs").value(true)
		end)
		vim.keymap.set({ "o", "x" }, "aV", function()
			require("various-textobjs").value(false)
		end)

		vim.keymap.set({ "o", "x" }, "ik", function()
			require("various-textobjs").key(true)
		end)
		vim.keymap.set({ "o", "x" }, "ak", function()
			require("various-textobjs").key(false)
		end)

		local text_obj_group = vim.api.nvim_create_augroup("TextObjectPluginGroup", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = text_obj_group,
			pattern = { "md" },
			callback = function()
				vim.keymap.set({ "o", "x" }, "il", function()
					require("various-textobjs").mdlink(true)
				end)
				vim.keymap.set({ "o", "x" }, "al", function()
					require("various-textobjs").mdlink(false)
				end)
				vim.keymap.set({ "o", "x" }, "iC", function()
					require("various-textobjs").mdFencedCodeBlock(true)
				end)
				vim.keymap.set({ "o", "x" }, "aC", function()
					require("various-textobjs").mdFencedCodeBlock(false)
				end)
			end,
			desc = "Map q to close buffer",
		})
	end,
	config = function()
		require("various-textobjs").setup({ useDefaultKeymaps = false })
	end,
}
