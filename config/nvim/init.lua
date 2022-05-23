-- ._____. ._____. ._____________________________________________________________________. ._____. ._____.
-- | ._. | | ._. | | ._________________________________________________________________. | | ._. | | ._. |
-- | !_| |_|_|_! | | !_________________________________________________________________! | | !_| |_|_|_! |
-- !___| |_______! !_____________________________________________________________________! !___| |_______!
-- .___|_|_| |_________________________________________________________________________________|_|_| |___.
-- | ._____| |_____________________________________________________________________________________| |_. |
-- | !_! | | |                                                                                 | | ! !_! |
-- !_____! | | Welcome to my init.lua!  The primary files around these parts are the ftplugin  | | !_____!
-- ._____. | |  cohort, and the plugins file with all the configs it requires.  Normally all   | | ._____.
-- | ._. | | | the configs for the plugins live in the packer:use's config, HOWEVER, impatient | | | ._. |
-- | | | | | |   needs to be loaded first before anything else, so that breaks the rules...    | | | | | |
-- | | | | | |                                                                                 | | | | | |
-- | | | | | |  Hopefully the nvim autocmd api comes out soon to remove the last remnants of   | | | | | |
-- | !_! | | |                         vimscript from the whole thing                          | | ! !_! |
-- !_____! | |                                                                                 | | !_____!
-- ._____. | |                                                                                 | | ._____.
-- | ._. | | |                                                                       ZT        | | | ._. |
-- | !_| |_|_|_________________________________________________________________________________| |_|_|_! |
-- !___| |_____________________________________________________________________________________| |_______!
-- .___|_|_| |___. ._____________________________________________________________________. .___|_|_| |___.
-- | ._____| |_. | | ._________________________________________________________________. | | ._____| |_. |
-- | !_! | | !_! | | !_________________________________________________________________! | | !_! | | !_! |
-- !_____! !_____! !_____________________________________________________________________! !_____! !_____!

require("impatient")

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

vim.cmd("colorscheme kanagawa")
