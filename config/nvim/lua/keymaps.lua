local map = vim.keymap.set
local function append(char)
	return [[:s/\(.\)$/\1]] .. char .. [[/<cr>]]
end

map("n", "<LocalLeader>,", append(","), { silent = true, desc = "Append comma" })
map("n", "<LocalLeader>;", append(";"), { silent = true, desc = "Append semicolon" })

map("n", "<Leader>wl", ":rightbelow vsp<CR>", { silent = true, desc = "Split right" })
map("n", "<Leader>wh", ":leftabove vsp<CR>", { silent = true, desc = "Split left" })
map("n", "<Leader>wk", ":leftabove sp<CR>", { silent = true, desc = "Split up" })
map("n", "<Leader>wj", ":rightbelow sp<CR>", { silent = true, desc = "Split down" })
map("n", "<C-j>", "<C-W><C-J>", { silent = true, desc = "select window below" })
map("n", "<C-k>", "<C-W><C-k>", { silent = true, desc = "select window above" })
map("n", "<C-l>", "<C-W><C-l>", { silent = true, desc = "select window to the right" })
map("n", "<C-h>", "<C-W><C-h>", { silent = true, desc = "select window to the left" })

map("n", "<Leader>wL", "<C-W>L", { silent = true, desc = "Move window right" })
map("n", "<Leader>wK", "<C-W>K", { silent = true, desc = "Move window up" })
map("n", "<Leader>wJ", "<C-W>J", { silent = true, desc = "Move window down" })
map("n", "<Leader>wH", "<C-W>H", { silent = true, desc = "Move window left" })

map("n", "[q", "<cmd>cp<cr>", { silent = true, desc = "goto prev entry in qf" })
map("n", "]q", "<cmd>cn<cr>", { silent = true, desc = "goto next entry in qf" })
map("n", "<Up>", ":res +5<Cr>", { silent = true })
map("n", "<Down>", ":res -5<Cr>", { silent = true })
map("n", "<Left>", ":vertical resize -5<Cr>", { silent = true })
map("n", "<Right>", ":vertical resize +5<Cr>", { silent = true })
map("n", "<C-n>", ":let @/=expand('<cword>')<cr>cgn", { silent = true })
map("n", "Q", "<nop>", { silent = true })

map("n", "<Leader>yf", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
end, { silent = true, desc = "copy file path to clipboard" })
map("n", "<Leader>yF", function()
	vim.fn.setreg("+", vim.fn.expand("%") + ":" + vim.fn.line("."))
end, { silent = true, desc = "copy file path with line no to clipboard" })

map("n", "<Leader>@", function()
	local reg = vim.fn.getcharstr()
	local reg_content = vim.fn.getreg(reg)
	local replaced_reg_content = vim.fn.input("> ", reg_content)
	vim.fn.setreg(reg, replaced_reg_content)
end, { silent = true, desc = "Edit a macro" })

map("i", "<C-A>", "<c-o>^", { desc = "Beginning of line" })
map("i", "<C-E>", "<c-o>$", { desc = "End of line" })
map("i", "<C-B>", "<Left>", { desc = "Move 1 char left" })
map("i", "<C-F>", "<Right>", { desc = "Move 1 char right" })
map("i", "<A-f>", "<Esc>lwi", { desc = "Move 1 `word` right" })
map("i", "<A-b>", "<c-o>b", { desc = "Move 1 `word` left" })

map("x", ".", ":norm .<cr>", {})

map("n", "[e", function()
	vim.diagnostic.jump({ wrap = false, severity = vim.diagnostic.severity.ERROR, float = true, count = -1 })
end, { silent = false, desc = "Go to previous diagnostic" })
map("n", "]e", function()
	vim.diagnostic.jump({ wrap = false, severity = vim.diagnostic.severity.ERROR, float = true, count = 1 })
end, { silent = false, desc = "Go to next diagnostic" })
map("n", "<Leader>q", function()
	local all = { -- ALL
		vim.diagnostic.severity.ERROR,
		vim.diagnostic.severity.WARN,
		vim.diagnostic.severity.INFO,
		vim.diagnostic.severity.HINT,
	}

	local sevs = {
		e = vim.diagnostic.severity.ERROR,
		w = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
	}

	local level = sevs[vim.fn.getcharstr()] or all
	vim.diagnostic.setqflist({ severity = level })
end, {
	silent = false,
	desc = "Send diagnostics to location list",
})

map("n", "<Leader>E", vim.diagnostic.open_float, { silent = false, desc = "Show diagnostic in float" })

map("n", "<leader>e", function()
	vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
		callback = function()
			vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
			return true
		end,
	})
end, { desc = "show diagnostics virtually" })

map("c", "<C-f>", '<C-R>=expand("%:p")<CR>', { silent = false })
map("c", "<C-a>", "<Home>", { silent = false })
map("c", "<C-e>", "<End>", { silent = false })
map("c", "<C-h>", "<Left>", { silent = false })
map("c", "<C-j>", "<Down>", { silent = false })
map("c", "<C-k>", "<Up>", { silent = false })
map("c", "<C-l>", "<Right>", { silent = false })
map("c", "<C-d>", "<Del>", { silent = false })

-- map("x", "<leader>ad", function()
-- 	-- Helper function to convert region to text
-- 	local function region_to_text(region)
-- 		local text = ""
-- 		local maxcol = vim.v.maxcol
-- 		for line, cols in vim.spairs(region) do
-- 			local endcol = cols[2] == maxcol and -1 or cols[2]
-- 			local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
-- 			text = ("%s%s\n"):format(text, chunk)
-- 		end
-- 		return text
-- 	end
--
-- 	-- Get the visual selection
-- 	local region = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)
-- 	local selected_text = region_to_text(region)
--
-- 	-- Diagon subcommands
-- 	local diagon_types = {
-- 		"Math",
-- 		"Sequence",
-- 		"Tree",
-- 		"Frame",
-- 		"Table",
-- 		"GraphPlanar",
-- 		"GraphDAG",
-- 		"Flowchart",
-- 	}
--
-- 	-- Show selection menu
-- 	vim.ui.select(diagon_types, {
-- 		prompt = "Select Diagon diagram type:",
-- 		format_item = function(item)
-- 			return item
-- 		end,
-- 	}, function(choice)
-- 		if not choice then
-- 			return -- User cancelled
-- 		end
--
-- 		-- Check if diagon is available
-- 		if vim.fn.executable("diagon") ~= 1 then
-- 			vim.notify("diagon not found in PATH. Please install it.", vim.log.levels.ERROR)
-- 			return
-- 		end
--
-- 		-- local cmd = string.format("'<,'>!diagon %s", choice)
-- 		-- vim.cmd(cmd)
--
-- 		-- Run diagon with selected text
-- 		local cmd = string.format("diagon %s", choice)
-- 		vim.print("selected_text", selected_text)
-- 		local output = vim.fn.system(cmd, selected_text)
-- 		vim.print(output)
--
-- 		-- Check for errors
-- 		if vim.v.shell_error ~= 0 then
-- 			vim.notify(string.format("diagon error: %s", output), vim.log.levels.ERROR)
-- 			return
-- 		end
--
-- 		-- Insert diagram below selection
-- 		local diagram_lines = vim.split(output, "\n", { plain = true, trimempty = false })
--
-- 		-- Remove trailing empty line if present
-- 		if diagram_lines[#diagram_lines] == "" then
-- 			table.remove(diagram_lines)
-- 		end
--
-- 		-- Wrap diagram based on filetype
-- 		local filetype = vim.bo.filetype
-- 		local wrapped_lines = {}
--
-- 		if filetype == "markdown" then
-- 			-- Markdown code block
-- 			table.insert(wrapped_lines, "```")
-- 			vim.list_extend(wrapped_lines, diagram_lines)
-- 			table.insert(wrapped_lines, "```")
-- 		elseif filetype == "org" then
-- 			-- Org mode source block
-- 			table.insert(wrapped_lines, "#+begin_src")
-- 			vim.list_extend(wrapped_lines, diagram_lines)
-- 			table.insert(wrapped_lines, "#+end_src")
-- 		else
-- 			-- Comment block for other filetypes
-- 			local commentstring = vim.bo.commentstring
-- 			if commentstring and commentstring ~= "" then
-- 				-- Parse commentstring (e.g., "// %s" or "/* %s */")
-- 				local comment_start = commentstring:match("^(.*)%%s")
-- 				local comment_end = commentstring:match("%%s(.*)$")
--
-- 				if comment_start and comment_end then
-- 					-- Multi-line comment style (e.g., /* */)
-- 					if comment_start:match("%S") and comment_end:match("%S") then
-- 						table.insert(wrapped_lines, comment_start:gsub("%%s", ""):match("^%s*(.-)%s*$"))
-- 						vim.list_extend(wrapped_lines, diagram_lines)
-- 						table.insert(wrapped_lines, comment_end:match("^%s*(.-)%s*$"))
-- 					else
-- 						-- Single-line comment style (e.g., //, #)
-- 						local prefix = comment_start:match("^%s*(.-)%s*$")
-- 						for _, line in ipairs(diagram_lines) do
-- 							table.insert(wrapped_lines, prefix .. " " .. line)
-- 						end
-- 					end
-- 				else
-- 					-- Fallback: no comment style, just insert as-is
-- 					wrapped_lines = diagram_lines
-- 				end
-- 			else
-- 				-- No commentstring defined, insert as-is
-- 				wrapped_lines = diagram_lines
-- 			end
-- 		end
--
-- 		-- Insert below the selection
-- 		vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { "" })
-- 		vim.api.nvim_buf_set_lines(0, end_line + 1, end_line + 1, false, wrapped_lines)
--
-- 		-- Move cursor to start of inserted diagram
-- 		vim.api.nvim_win_set_cursor(0, { end_line + 2, 0 })
--
-- 		vim.notify(string.format("Generated %s diagram", choice), vim.log.levels.INFO)
-- 	end)
-- end, { silent = true, desc = "Generate ASCII diagram with Diagon" })

-- let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

-- nnoremap cn *``cgn
-- nnoremap cN *``cgN

-- vnoremap <expr> cn g:mc . "``cgn"
-- vnoremap <expr> cN g:mc . "``cgN"

-- function! SetupCR()
--   nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
-- endfunction

-- nnoremap cq :call SetupCR()<CR>*``qz
-- nnoremap cQ :call SetupCR()<CR>#``qz

-- vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
-- vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
