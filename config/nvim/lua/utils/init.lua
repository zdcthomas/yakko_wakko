function Pr(...)
	if ... == nil then
		print("nil")
		return ...
	end
	local args = {}
	for _, arg in ipairs({ ... }) do
		table.insert(args, vim.inspect(arg))
	end
	print(unpack(args))
	return ...
end

local levels = {
	errors = vim.diagnostic.severity.ERROR,
	warnings = vim.diagnostic.severity.WARN,
	info = vim.diagnostic.severity.INFO,
	hints = vim.diagnostic.severity.HINT,
}

function GetAllDiagnostics(bufnr)
	local result = {}
	for k, level in pairs(levels) do
		result[k] = #vim.diagnostic.get(bufnr, { severity = level })
	end

	return result
end

if pcall(require, "plenary") then
	RELOAD = require("plenary.reload").reload_module

	R = function(name)
		RELOAD(name)
		return require(name)
	end
end

function Pquire(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end
