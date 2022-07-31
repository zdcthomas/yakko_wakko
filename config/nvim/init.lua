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

-- On first install, this won't be here
pcall(require, "impatient")

-- Settings.lua contains all global options that are set. Most of these will
-- should have a description. This has to come first, since it defines the
-- mapleader, and many many other keymappings require that to be set.
require("settings")

-- Utils are a series of globally available lua functions that
--provide common functionality accross my dotfiles.
require("utils")

-- Defines a list of plugins to pull down and use, as well as their
-- configurations.
require("plugins")

-- This defines user commands. `:h user-commands` to learn more!
require("commands")

-- Defines global autocmds. `:h autocmd` and `:h nvim_create_autocmd`
require("autocmds")

-- Defines global keymaps. `:h vim.keymap` and `:h map` to learn more!
require("keymaps")

vim.cmd("colorscheme rose-pine")
