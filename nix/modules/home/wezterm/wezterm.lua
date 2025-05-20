-- Locals defined in ./default.nix
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Tokyo Night Storm"
---@diagnostic disable-next-line: undefined-global
config.window_decorations = WINDOW_DECORATION
config.enable_wayland = true
config.adjust_window_size_when_changing_font_size = false
---@diagnostic disable-next-line: undefined-global
config.font_size = FONT_SIZE

---@diagnostic disable-next-line: undefined-global
config.window_background_opacity = OPACITY
config.text_background_opacity = 1
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.warn_about_missing_glyphs = false
local font_name = "PragmataPro Mono Liga"

local function font_with_fallback(name, params)
	local names = { name, "Iosevka Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

config.font = wezterm.font(font_name)
config.font_rules = {
	{
		italic = true,
		font = font_with_fallback(font_name, { italic = true, bold = true }),
	},
	{
		italic = true,
		intensity = "Bold",
		font = font_with_fallback(font_name, { italic = true, bold = true }),
	},
	{
		intensity = "Bold",
		font = font_with_fallback(font_name, { bold = true }),
	},
}

local function recompute_opacity(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	if window_dims.is_full_screen then
		local new_opacity = 1
		if overrides.window_background_opacity and new_opacity == overrides.window_background_opacity then
			return
		end
		overrides.window_background_opacity = new_opacity
	else
		-- wezterm.log_info("window is not full screen")
		---@diagnostic disable-next-line: undefined-global
		overrides.window_background_opacity = DEFAULT_OPACITY
	end
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, pane)
	recompute_opacity(window)
end)

wezterm.on("window-config-reloaded", function(window)
	recompute_opacity(window)
end)

config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
}

return config
