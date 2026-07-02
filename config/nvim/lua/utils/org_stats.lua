-- Scans org agenda files with plain file reads so the dashboard can show
-- inbox/due counts without loading the orgmode plugin at startup.
local M = {}

local wiki = vim.fn.expand("~/Irulan/wiki")
local inbox_file = wiki .. "/agenda/inbox.org"

local unfinished = { TODO = true, QUESTION = true, EDIT = true }
local finished = { DONE = true, DELEGATED = true, ABANDONED = true, ANSWERED = true }

local function parse_heading(line)
	local rest = line:match("^%*+%s+(.*)")
	if not rest then
		return nil
	end
	local keyword = rest:match("^(%u+)%s") or rest:match("^(%u+)$")
	if not (unfinished[keyword] or finished[keyword]) then
		keyword = nil
	end
	local title = keyword and vim.trim(rest:sub(#keyword + 1)) or rest
	return { keyword = keyword, title = title }
end

-- end of the agenda week (orgmode weeks run Mon-Sun); overdue items also
-- show in the week view, so anything dated on or before this counts as due
local function end_of_week()
	local wday = tonumber(os.date("%w")) -- 0 = Sunday
	return os.date("%Y-%m-%d", os.time() + ((7 - wday) % 7) * 86400)
end

---@return { inbox: table[], due: table[] }
function M.collect()
	local result = { inbox = {}, due = {} }
	local eow = end_of_week()
	local files = vim.fn.globpath(wiki .. "/agenda", "**/*.org", false, true)
	vim.list_extend(files, vim.fn.globpath(wiki .. "/writing", "**/*.org", false, true))
	for _, path in ipairs(files) do
		local current, counted
		for line in io.lines(path) do
			local heading = parse_heading(line)
			if heading then
				current, counted = heading, false
				if path == inbox_file and unfinished[heading.keyword] then
					table.insert(result.inbox, heading)
				end
			elseif current and not counted and unfinished[current.keyword] then
				local date = line:match("SCHEDULED:%s*<(%d%d%d%d%-%d%d%-%d%d)")
					or line:match("DEADLINE:%s*<(%d%d%d%d%-%d%d%-%d%d)")
				if date and date <= eow then
					counted = true
					table.insert(result.due, { date = date, keyword = current.keyword, title = current.title })
				end
			end
		end
	end
	table.sort(result.due, function(a, b)
		return a.date < b.date
	end)
	return result
end

local function fmt_due(item)
	local y, m, d = item.date:match("(%d+)-(%d+)-(%d+)")
	local day = os.date("%a %d", os.time({ year = y, month = m, day = d, hour = 12 }))
	return ("%s · %s %s"):format(day, item.keyword, item.title)
end

local function fmt_inbox(item)
	return ("%s %s"):format(item.keyword, item.title)
end

-- mini agenda for the dashboard footer
---@param stats { inbox: table[], due: table[] } result of M.collect()
function M.footer_lines(stats, max)
	max = max or 5
	local lines = {}
	local function section(label, items, fmt)
		if #items == 0 then
			return
		end
		table.insert(lines, "")
		table.insert(lines, ("──── %s ────"):format(label))
		for i = 1, math.min(#items, max) do
			table.insert(lines, fmt(items[i]))
		end
		if #items > max then
			table.insert(lines, ("… and %d more"):format(#items - max))
		end
	end
	section("due this week", stats.due, fmt_due)
	section("inbox", stats.inbox, fmt_inbox)
	return lines
end

return M
