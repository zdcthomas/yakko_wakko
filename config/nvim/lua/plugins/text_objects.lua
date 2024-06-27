return {
	"chrisgrieser/nvim-various-textobjs",
	init = function()
		vim.keymap.set({ "o", "x" }, "an", function()
			require("various-textobjs").number(false)
		end)
		vim.keymap.set({ "o", "x" }, "in", function()
			require("various-textobjs").number(true)
		end)
		vim.keymap.set("n", "dsi", function()
			-- select outer indentation
			require("various-textobjs").indentation("outer", "outer")

			-- plugin only switches to visual mode when a textobj has been found
			local indentationFound = vim.fn.mode():find("V")
			if not indentationFound then
				return
			end

			-- dedent indentation
			vim.cmd.normal({ "<", bang = true })

			-- delete surrounding lines
			local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
			local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
			vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
			vim.cmd(tostring(startBorderLn) .. " delete")
		end, { desc = "Delete Surrounding Indentation" })

		-- exception: indentation textobj requires two parameters, first for exclusion of the
		-- starting border, second for the exclusion of ending border
		vim.keymap.set({ "o", "x" }, "ii", function()
			require("various-textobjs").indentation("inner", "inner")
		end)
		vim.keymap.set({ "o", "x" }, "ai", function()
			require("various-textobjs").indentation("outer", "inner")
		end)
		vim.keymap.set({ "o", "x" }, "aI", function()
			require("various-textobjs").indentation("outer", "outer")
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

		vim.keymap.set({ "o", "x" }, "iL", function()
			require("various-textobjs").url()
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
		require("various-textobjs").setup({
			useDefaultKeymaps = false,
			lookForwardLines = 0, -- set to 0 to only look in the current line
		})
	end,
}
