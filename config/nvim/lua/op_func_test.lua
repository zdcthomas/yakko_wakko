--local Module = {
--	transformations = {},
--	debug_level = 0,
--	__opfunc = function(type)
--		print(type)
--	end,
--}

--vim.keymap.set("n", "<leader><leader>s", function()
--	local path = "~/yakko_wakko/config/nvim/lua/op_func_test.lua"
--	vim.cmd("messages clear")
--	vim.pretty_print("Resourcing Op func file")
--	vim.cmd("source " .. path)
--end)

---- mapping of key to operator func callback,

--local function get_mark(mark)
--	local position = vim.api.nvim_buf_get_mark(0, mark)
--	if position[1] == 0 then
--		return nil
--	end
--	position[2] = position[2] + 1
--	return position
--end

--local function get_input(prompt)
--	return string.format(
--		"%s",
--		vim.fn.input({
--			prompt = prompt,
--			cancelreturn = nil,
--		})
--	)
--end

---- [[
---- Directly calls into get_lines api
---- ]]
--local get_lines = function(start, stop)
--	return vim.api.nvim_buf_get_lines(0, start - 1, stop, false)
--end

---- [[
---- Directly calls into get_text api
---- ]]
--local get_text = function(first_position, last_position)
--	-- I don't understand why this is right, but everything else isn't.
--	return vim.api.nvim_buf_get_text(
--		0,
--		first_position[1] - 1, -- row
--		first_position[2] - 1, -- col
--		last_position[1] - 1, -- row
--		last_position[2], -- col
--		{}
--	)
--end

--local function get_line_from_type(callback_type, first_position, last_position)
--	-- different types of operator funcs need different ways of getting lines
--	if callback_type == "line" then
--		return get_lines(first_position[1], last_position[1])
--	elseif callback_type == "char" then
--		return get_text(first_position, last_position)
--	elseif callback_type == "block" then
--		-- we use reg a just cause
--		--
--		local old_reg = vim.fn.getreg("a")
--		vim.pretty_print(old_reg)
--		vim.cmd([[norm! gv"ay ]])
--		local lines = vim.split(vim.fn.getreg([[a]]), "\n")
--		vim.pretty_print(lines)
--		vim.fn.setreg("a", old_reg)
--		return lines
--	else
--		vim.pretty_print("callback_type ", callback_type, " is un-supported")
--		return
--	end
--end

--local set_lines = function(start, stop, lines)
--	vim.api.nvim_buf_set_lines(0, start - 1, stop, false, lines)
--end

--local function get_positions(callback_type)
--	-- TODO: This should be driven by the type
--	Pr("callback_type", callback_type)

--	vim.o.selection = "inclusive"
--	-- it seems like these marks work properly in visual mode as well, but I'm not sure yet
--	return get_mark("["), get_mark("]")
--end

--local function create_callback(funk)
--	return function(callback_type)
--		vim.o.selection = "inclusive"
--		local first_position, last_position = get_positions(callback_type)

--		local lines = get_line_from_type(callback_type, first_position, last_position)
--		if not lines then
--			return
--		end

--		-- Use the callback defined by the user to transform the lines
--		local maybe_lines = funk(lines, { first = first_position, last = last_position })
--		if not maybe_lines then
--			return
--		else
--			lines = maybe_lines
--		end

--		if callback_type == "line" then
--			set_lines(first_position[1], last_position[1], lines)
--		elseif callback_type == "char" then
--			-- Replace the lines in the correct buffer
--			vim.api.nvim_buf_set_text(
--				0,
--				first_position[1] - 1,
--				first_position[2] - 1,
--				last_position[1] - 1,
--				last_position[2],
--				lines
--			)
--		end
--	end
--end

--function Module.linewise(callback_funk)
--	return function()
--		vim.api.nvim_feedkeys("^", "n", false)
--		callback_funk()
--		vim.api.nvim_feedkeys("g_", "n", false)
--	end
--end

--function Module.create_operator(funk)
--	return function()
--		local old_op_func = vim.o.operatorfunc
--		Module.__opfunc = create_callback(funk)
--		vim.o.operatorfunc = "v:lua.require'op_func_test'.__opfunc"
--		vim.api.nvim_feedkeys("g@", "n", false)
--		-- vim.o.operatorfunc = old_op_func
--	end
--end

---- vim.keymap.set(
---- 	"n",
---- 	",",
---- 	Module.create_operator(function(lines) -- the transformation function
---- 		for index, value in ipairs(lines) do
---- 			lines[index] = value .. ","
---- 		end
---- 		return lines
---- 	end)
---- )

--vim.keymap.set(
--	"n",
--	",",
--	Module.create_operator(function(lines)
--		for index, value in ipairs(lines) do
--			lines[index] = "," .. value .. ","
--		end
--		return lines
--	end)
--)
---- Module.setup(setup_shape)

--return Module
