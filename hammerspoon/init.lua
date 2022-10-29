-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
-- 	hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "H", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - 10
-- 	win:setFrame(f)
-- end)
local bigHome = "PX329"
local laptop_screen = "Built-in Retina Display"

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
		{ "Slack", nil, laptopScreen, hs.layout.maximized, nil, nil },
		{ "Kitty", nil, bigHome, hs.layout.maximized, nil, nil },
	}
	hs.layout.apply(windowLayout)
end)
-- caffeine = hs.menubar.new()
-- function setCaffeineDisplay(state)
-- 	if state then
-- 		caffeine:setTitle("AWAKE")
-- 	else
-- 		caffeine:setTitle("SLEEPY")
-- 	end
-- end

-- function caffeineClicked()
-- 	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
-- end

-- if caffeine then
-- 	caffeine:setClickCallback(caffeineClicked)
-- 	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
-- end

-- hs.loadSpoon("AClock")
-- hs.hotkey.bind({ "cmd", "alt" }, "t", function()
-- 	spoon.AClock:toggleShow()
-- end)

-- WINDOW MANAGERMENT
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Y", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - 10
-- 	f.y = f.y - 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "K", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.y = f.y - 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "U", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + 10
-- 	f.y = f.y - 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "H", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "L", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "B", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - 10
-- 	f.y = f.y + 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "J", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.y = f.y + 10
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "N", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + 10
-- 	f.y = f.y + 10
-- 	win:setFrame(f)
-- end)

hs.hotkey.bind({ "alt", "ctrl" }, "Left", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	win:setFrame(f)
end)

-- hs.hotkey.bind({ "alt", "ctrl" }, "Right", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()
-- 	local screen = win:screen()
-- 	local max = screen:frame()

-- 	f.x = max.x + (max.w / 2)
-- 	f.y = max.y
-- 	f.w = max.w / 2
-- 	f.h = max.h
-- 	win:setFrame(f)
-- end)

local meh = { "alt", "ctrl" }
local super = { "cmd", "alt", "ctrl" }

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

hs.hotkey.bind({ "alt" }, "h", function()
	hs.window.focusedWindow():focusWindowWest()
end)
hs.hotkey.bind({ "alt" }, "j", function()
	hs.window.focusedWindow():focusWindowSouth()
end)

hs.hotkey.bind({ "alt" }, "k", function()
	hs.window.focusedWindow():focusWindowNorth()
end)
hs.hotkey.bind({ "alt" }, "l", function()
	hs.window.focusedWindow():focusWindowEast()
end)

-- hyper.bindShiftKey("3", function()
--   wm.moveWindowToPosition(wm.screenPositions.bottomLeft)
-- end)
-- hyper.bindShiftKey("4", function()
--   wm.moveWindowToPosition(wm.screenPositions.bottomRight)
-- end)
-- hyper.bindShiftKey("5", function()
--   wm.moveWindowToPosition(wm.screenPositions.top)
-- end)
-- hyper.bindShiftKey("6", function()
--   wm.moveWindowToPosition(wm.screenPositions.bottom)
-- end)
