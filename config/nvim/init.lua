-- ._____. ._____. ._____________________________________________________. ._____. ._____.
-- | ._. | | ._. | | ._________________________________________________. | | ._. | | ._. |
-- | !_| |_|_|_! | | !_________________________________________________! | | !_| |_|_|_! |
-- !___| |_______! !_____________________________________________________! !___| |_______!
-- .___|_|_| |_________________________________________________________________|_|_| |___.
-- | ._____| |_____________________________________________________________________| |_. |
-- | !_! | | |                                                                 | | ! !_! |
-- !_____! | |               Welcome to my init.lua! Aside from                | | !_____!
-- ._____. | |     impatient(https://github.com/lewis6991/impatient.nvim)      | | ._____.
-- | ._. | | |    the rest of the `require`s handle my settings, commands,     | | | ._. |
-- | | | | | | plugins etc. But there's also ftplugin, ftdetect, compiler etc. | | | | | |
-- | | | | | |                (`:h runtimpath` for more info).                 | | | | | |
-- | | | | | |                                                                 | | | | | |
-- | | | | | |  You should also be able to follow the `README`s in each dir.   | | | | | |
-- | | | | | |                                                                 | | | | | |
-- | !_! | | |       Feel free to hang around, ask questions, make a PR,       | | ! !_! |
-- !_____! | |                submit an issue, or just say hi!                 | | !_____!
-- ._____. | |                                                                 | | ._____.
-- | ._. | | |                               ZT                                | | | ._. |
-- | !_| |_|_|_________________________________________________________________| |_|_|_! |
-- !___| |_____________________________________________________________________| |_______!
-- .___|_|_| |___. ._____________________________________________________. .___|_|_| |___.
-- | ._____| |_. | | ._________________________________________________. | | ._____| |_. |
-- | !_! | | !_! | | !_________________________________________________! | | !_! | | !_! |
-- !_____! !_____! !_____________________________________________________! !_____! !_____!
---@diagnostic disable: assign-type-mismatch

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Configuration for my package manager: [ Lazy.nvim ](https://github.com/folke/lazy.nvim.git)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Defines a list of plugins to pull down and use, as well as their
-- configurations.
require("lazy").setup("plugins", {
	dev = {
		-- directory where you store your local plugin projects
		path = "~/dev",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		-- patterns = { "zdcthomas" }, -- For example {"folke"}
	},
	defaults = {
		lazy = true,
	},
	install = { colorscheme = { "everforest", "slate" } },
	performance = {
		rtp = {
			disabled_plugins = {
				"netrw",
				"2html_plugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"tohtml",
				"tutor",
				"tar",
				"tarPlugin",
				"rrhelper",
				"vimball",
				"vimballPlugin",
			},
		},
	},
})

-- Settings.lua contains all global options that are set. Most of these will
-- should have a description. This has to come first, since it defines the
-- mapleader, and many many other keymappings require that to be set.
require("settings")

-- Defines global autocmds. `:h autocmd` and `:h nvim_create_autocmd`
require("autocmds")

-- Defines global keymaps. `:h vim.keymap` and `:h map` to learn more!
require("keymaps")

vim.cmd.colorscheme("gruvbox")
