local Module = {}

Module.setup = function()
	require("startup").setup({
		header = {
			content = {
				[[._____. ._____. .____________________. ._____. ._____.]],
				[[| ._. | | ._. | | .________________. | | ._. | | ._. |]],
				[[| !_| |_|_|_! | | !________________! | | !_| |_|_|_! |]],
				[[!___| |_______! !____________________! !___| |_______!]],
				[[.___|_|_| |________________________________|_|_| |___.]],
				[[| ._____| |____________________________________| |_. |]],
				[[| !_! | | |                                | | ! !_! |]],
				[[!_____! | |            &&                  | | !_____!]],
				[[._____. | |          &&&&&                 | | ._____.]],
				[[| ._. | | |  ,  &  &&&\/& &&&              | | | ._. |]],
				[[| | | | | | &-\* &&&|,/ *|/& &&            | | | | | |]],
				[[| | | | | |  . *&_ &&/   /, /_&  &&        | | | | | |]],
				[[| | | | | |   &_\\    \\  { &|__&_&/_&     | | | | | |]],
				[[| | | | | |  ^   \\_&_{*&/ /          &&&  | | | | | |]],
				[[| | | | | |          `, \{__&_&__&_&_/_&&  | | | | | |]],
				[[| | | | | |           } }{ * @  &\\'       | | | | | |]],

				[[| | | | | |           }{{         \'_&__&  | | | | | |]],
				[[| | | | | |          {}{           \ `&\&& | | | | | |]],
				[[| !_! | | |          {{}             '&@   | | ! !_! |]],
				[[!_____! | |    ,--=-~{ .-^-\_,_            | | !_____!]],
				[[._____. | |          `}                    | | ._____.]],
				[[| ._. | | |           {                    | | | ._. |]],
				[[| !_| |_|_|________________________________| |_|_|_! |]],
				[[!___| |____________________________________| |_______!]],
				[[.___|_|_| |___. .____________________. .___|_|_| |___.]],
				[[| ._____| |_. | | .________________. | | ._____| |_. |]],
				[[| !_! | | !_! | | !________________! | | !_! | | !_! |]],
				[[!_____! !_____! !____________________! !_____! !_____!]],
				[[                                                      ]],
			},
			type = "text",
			align = "center",
			highlight = "Type",
		},
		time = {
			align = "center",
			type = "text",
			title = "Info",
			content = require("startup.functions").date_time,
			highlight = "Function",
		},
		plugins = {
			align = "center",
			type = "text",
			title = "Info",
			content = require("startup.functions").packer_plugins,
			highlight = "Function",
		},
		mappings = {
			execute_command = "<CR>",
			open_file = "o",
			open_file_split = "<c-o>",
			open_section = "<CR>",
			open_help = "?",
		},
		commands = {
			type = "mapping",
			align = "center",
			title = "commands",
			fold_section = false,
			content = {
				{ "Open dotfiles", ":!dmux ~/yakko_wakko", "d" },
				{ "Dmux", ":!dmux", "D" },
				{ "File Search", "<cmd>Telescope find_files<CR>", "p" },
				{ "Compile Packer", ":PackerCompile", "C" },
				{ "Sync Packer", ":PackerSync", "s" },
				{ "Bounce", ":q<CR>", "q" },
			},
			highlight = "#E5E9F0",
		},
		oldies = {
			type = "oldfiles",
			oldfiles_directory = true,
			align = "center",
			fold_section = false,
			title = "ファイル",
			margin = 5,
			content = {},
			highlight = "String",
			default_color = "#FFFFFF",
			oldfiles_amount = 5,
		},
		options = {
			mapping_keys = true,
			empty_lines_between_mappings = false,
			disable_statuslines = true,
			paddings = { 1, 1, 1, 1, 1 },
			after = function()
				require("startup.utils").oldfiles_mappings()
			end,
		},
		parts = { "header", "oldies", "commands", "time", "plugins" },
	})
end

return Module
