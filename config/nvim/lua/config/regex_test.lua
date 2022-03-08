-- .	all characters
-- %a	letters
-- %c	control characters
-- %d	digits
-- %l	lower case letters
-- %p	punctuation characters
-- %s	space characters
-- %u	upper case letters
-- %w	alphanumeric characters
-- %x	hexadecimal digits
-- %z	the character with representation 0
--
-- local markdown_capture = "%(([%w%p%C]+)%)%[([%a%S%./~]+)%]"
local link_description_inner_match = "[%w%s]+"
local real_link_inner_match = "[%w%p]+"
local markdown_capture = "%[(" .. link_description_inner_match .. ")%]%((" .. real_link_inner_match .. ")%)"
local line_with_multiple_links = "[this is link 1](link_1) and over here [is link 2](link_2)"

local markdown_link_match = "%s%(.+%)%[.*%]%s"
local lines_string = "this line is just a [This is, the link!](bar/foo/link_title.md)"

local function find_pattern_index_around_point(line, index, left, right)
	if (index <= 0) or (index > line:len()) then
		return nil
	end
	if index < 1 then
		index = 1
	end

	if index > line:len() then
		index = line:len()
	end

	local leftmost = index
	local done = false

	while not done do
		if leftmost < 1 then
			done = true
			break
		end
		-- - 1 here because a string of length 1 is 0 more than current leftmost
		if line:sub(leftmost, leftmost + (left:len() - 1)) == left then
			done = true
		else
			leftmost = leftmost - 1
		end
	end

	local rightmost = index
	done = false

	while not done do
		if rightmost > line:len() then
			done = true
			break
		end
		if line:sub(rightmost - (right:len() - 1), rightmost) == right then
			done = true
		else
			rightmost = rightmost + 1
		end
	end

	if (leftmost < 1) or (rightmost > line:len()) then
		return nil
	else
		return { left = leftmost, right = rightmost }
	end
end

local function get_link_content_around_position(line, link_location, link_style)
	local left
	local right
	local match
	if link_style == "wiki" then
		left = "[["
		right = "]]"
		match = "asldfkj"
	else
		left = "["
		right = ")"
		match = markdown_capture
	end
	local link_bounds = find_pattern_index_around_point(line, link_location, left, right)
	if link_bounds then
		local link_title, link = line:sub(link_bounds.left, link_bounds.right):match(markdown_capture)
		return { link_title = link_title, link = link }
	else
		return nil
	end
end

local function get_link_at_cursor(link_type)
	if not link_type then
		link_type = "md"
	end
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- the col need to be plus 1 because vim is 0 indexed, lua is 1 indexed. SIGH......
	return get_link_content_around_position(vim.api.nvim_get_current_line(), col + 1, link_type)
end

local function add_extension_if_none_present(link, extension)
	if not extension then
		extension = ".md"
	end
	if link:match("%.[%a%.]+$") then
		return link
	else
		return link .. extension
	end
	-- first figure out what kind of link it is
	-- it can be either
	-- * bare link, like [someting about verbs](verbs)
	-- * link_with_extension [something about verbs](verbs.md)
	-- Do I care about subdirs? I don't think so cause
	-- I'm just gonna :e the file or open up a buffer that already exists with that file
end

local function follow_link_under_cursor()
	local link = get_link_at_cursor()
	if not link then
		return
	end
	-- if link has no sub dirs, pass to add_extension_if_none_present, and e: that bad boy
	-- if there are subdirs, make whatever subdirs are needed
end

Pr(get_link_at_cursor())
