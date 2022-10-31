--  ---------------
--  |    Ideas    |
--  ---------------
-- Split out tab from browser into a new window

--  -------------------
--  |    Constants    |
--  -------------------

local meh = { "alt", "ctrl" }
local super = { "cmd", "alt", "ctrl" }
local preferedTerminal = "kitty"
local preferedTerminal = "Brave Browser"

--  ---------------
--  |    Utils    |
--  ---------------

Inspect = require("inspect")

--  -------------------
--  |    Constants    |
--  -------------------

local bigHome = "PX329"
local laptopScreen = "Built-in Retina Display"

--  ---------------------------------
--  |    Configuration reloading    |
--  ---------------------------------

function reloadConfig(files)
	doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

hs.hotkey.bind({ "alt", "cmd" }, "1", function()
	local windowLayout = {
		{ "Brave Browser", nil, laptopScreen, hs.layout.maximized, nil, nil },
		{ "kitty", nil, bigHome, hs.layout.maximized, nil, nil },
	}
	hs.layout.apply(windowLayout)
end)

--  ---------------------------
--  |    Window Management    |
--  ---------------------------

function break_out_tab()
	local brave = hs.appfinder.appFromName("Brave Browser")
	if not brave then
		return
	end
	local tab_item = brave:findMenuItem({ "Tab", "Move Tab to New Window" })
	if tab_item then
		brave:selectMenuItem(tab_item)
	end

	-- hs.application.laun
end

hs.hotkey.bind(super, "return", function()
	hs.application.launchOrFocus(preferedTerminal)
end)

hs.hotkey.bind(super, "k", function()
	print("focusing " .. preferedBrowser)
	hs.application.launchOrFocus(preferedBrowser)
end)

local wm = require("window_management")

-- Right now, all of these are just based on magnets which I used for a long long time,
-- however, I really want to change these to make more sense on a normal keyboard
hs.hotkey.bind(meh, "Return", function()
	wm.windowMaximize(0)
end)

hs.hotkey.bind(meh, "right", function()
	wm.moveWindowToPosition(wm.screenPositions.right)
end)

hs.hotkey.bind(super, "Right", function()
	hs.window.focusedWindow():moveOneScreenEast()
end)

hs.hotkey.bind(super, "Left", function()
	hs.window.focusedWindow():moveOneScreenWest()
end)

hs.hotkey.bind(meh, "left", function()
	wm.moveWindowToPosition(wm.screenPositions.left)
end)

hs.hotkey.bind(meh, "u", function()
	wm.moveWindowToPosition(wm.screenPositions.topLeft)
end)

hs.hotkey.bind(meh, "i", function()
	wm.moveWindowToPosition(wm.screenPositions.topRight)
end)

hs.hotkey.bind(meh, "k", function()
	wm.moveWindowToPosition(wm.screenPositions.bottomRight)
end)

hs.hotkey.bind(meh, "j", function()
	wm.moveWindowToPosition(wm.screenPositions.bottomLeft)
end)

-- hs.hotkey.bind({ "alt" }, "h", function()
-- 	hs.window.focusedWindow():focusWindowWest()
-- end)

-- hs.hotkey.bind({ "alt" }, "j", function()
-- 	hs.window.focusedWindow():focusWindowSouth()
-- end)

-- hs.hotkey.bind({ "alt" }, "k", function()
-- 	hs.window.focusedWindow():focusWindowNorth()
-- end)

-- hs.hotkey.bind({ "alt" }, "l", function()
-- 	hs.window.focusedWindow():focusWindowEast()
-- end)

-- local yabai = require("yabai")
