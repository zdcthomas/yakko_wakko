-- Locals defined in ./default.nix
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end
config.color_scheme = "Gruvbox Dark (Gogh)"

config.font = wezterm.font("PragmataPro Mono Liga")
config.enable_wayland = false
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
