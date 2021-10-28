local conf = {}

function conf.setup()
	vim.g.startify_commands = {
		{ p = { "Files", ":Telescope find_files" } },
		{ s = { "Sync Packer", ":PackerSync" } },
		{ c = { "Compile Packer", ":PackerCompile" } },
		{ d = { "Open dotfiles", ":!dmux ~/yakko_wakko" } },
		{ D = { "Dmux", ":!dmux" } },
	}
	vim.g.startify_lists = {
		{ type = "commands", header = { "   めいれい " } },
		{ type = "dir", header = { "   MRU " .. vim.fn.getcwd() } },
	}
	vim.g.sttartify_change_to_dir = 0
	vim.g.startify_change_to_vcs_root = 1
	local ascii = {
		[[             &&]],
		[[           &&&&&]],
		[[         &&&\/& &&&]],
		[[        &&|,/  |/& &&]],
		[[     *&_ &&/   /  /_&  &&]],
		[[    &_\\    \\  { &|__&_&/_&]],
		[[       \\_&_{*&/ /          &&&]],
		[[    ,      `, \{__&_&__&_&_/_&&]],
		[[   &        } }{      &\\']],
		[[            }{{         \'_&__&]],
		[[           {}{           \ `&\&&]],
		[[           {{}             '&&]],
		[[     ,--=-~{ .-^-\_,_         ]],
		[[ &,        `}                 ]],
		[[   .        { ]],
	}
	vim.g.startify_custom_header = ascii
end

return conf
