-- redline: review a spec with an agent, the way suggestion mode works in a word
-- processor. Run :Redline in the spec buffer. Its keys (]r, [r, <leader>r...) are
-- buffer-local and exist only after :Redline, so the <leader>r overlap with
-- org-roam (<leader>rc, <leader>rf) holds only in a redline buffer.
--
-- The plugin is a thin layer on the `redline` CLI, so it loads from the same Nix
-- package as the CLI (share/redline/nvim) and the two always match. The package
-- comes from the redline flake input. A machine without it gets no spec here.
-- A local `dir` plugin is not written to lazy-lock.json.
local function redline_dir()
	local bin = vim.fn.exepath("redline")
	if bin == "" then
		return nil
	end
	-- $PATH holds a profile symlink; the real path is <store path>/bin/redline.
	local real = vim.uv.fs_realpath(bin)
	if not real then
		return nil
	end
	local dir = vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(real)), "share", "redline", "nvim")
	if not vim.uv.fs_stat(dir) then
		return nil
	end
	return dir
end

local dir = redline_dir()
if not dir then
	return {}
end

return {
	{
		name = "redline",
		dir = dir,
		cmd = "Redline",
	},
}
