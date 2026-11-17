-- gq for markdown through mdslw (one sentence per line).
--
-- mdslw only treats lines as a table when it sees the header row and the
-- delimiter row. Given body rows alone (gqq on a row, a visual selection, gq}
-- from mid-table), it parses them as a paragraph and splits each row at every
-- sentence end. So a gq range that touches a table grows to cover the whole
-- table. mdslw passes a whole table through unchanged.
--
-- mdslw also drops trailing blank lines, so gqap used to delete the blank line
-- after the paragraph and merge it with the next one. Blank lines at either
-- end of the range are kept out of mdslw and put back afterwards.
--
-- Vim also calls formatexpr for 'textwidth' auto-wrap in insert mode. Table
-- rows are not wrapped there; everything else falls back to the internal wrap.
local M = {}

M.cmd = { "mdslw", "--max-width", "100" }

local table_query

-- 1-based, inclusive line ranges of every pipe table in the buffer.
local function table_ranges(buf)
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
	if not ok or not parser then
		return {}
	end
	table_query = table_query or vim.treesitter.query.parse("markdown", "(pipe_table) @table")
	local root = parser:parse()[1]:root()
	local ranges = {}
	for _, node in table_query:iter_captures(root, buf) do
		local srow, _, erow, ecol = node:range()
		-- The end is exclusive. A node that ends at column 0 stops on the row before.
		if ecol == 0 then
			erow = erow - 1
		end
		table.insert(ranges, { srow + 1, erow + 1 })
	end
	return ranges
end

local function is_blank(line)
	return line:match("^%s*$") ~= nil
end

local function in_table(lnum, tables)
	for _, r in ipairs(tables) do
		if lnum >= r[1] and lnum <= r[2] then
			return true
		end
	end
	return false
end

function M.formatexpr()
	local buf = vim.api.nvim_get_current_buf()
	local first = vim.v.lnum
	local last = first + vim.v.count - 1
	local tables = table_ranges(buf)

	if vim.fn.mode():find("^[iR]") then
		-- A row typed before its delimiter row exists is not a table yet for
		-- treesitter, so a leading pipe also counts.
		local line = vim.api.nvim_buf_get_lines(buf, first - 1, first, false)[1] or ""
		if line:match("^[%s>]*|") or in_table(first, tables) then
			return 0
		end
		return 1
	end

	for _, r in ipairs(tables) do
		if r[1] <= last and r[2] >= first then
			first = math.min(first, r[1])
			last = math.max(last, r[2])
		end
	end

	local lines = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)
	local lead, trail = 0, 0
	while lead < #lines and is_blank(lines[lead + 1]) do
		lead = lead + 1
	end
	if lead == #lines then
		return 0
	end
	while is_blank(lines[#lines - trail]) do
		trail = trail + 1
	end

	local body = vim.list_slice(lines, lead + 1, #lines - trail)
	local out = vim.fn.systemlist(M.cmd, body)
	if vim.v.shell_error ~= 0 then
		vim.notify("mdslw failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
		return 0
	end

	vim.api.nvim_buf_set_lines(buf, first - 1 + lead, last - trail, false, out)
	return 0
end

return M
