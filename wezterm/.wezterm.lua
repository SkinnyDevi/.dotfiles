local wezterm = require("wezterm")
local config = wezterm.config_builder()

function IsArchLinux()
	local os_release = io.open("/etc/arch-release", "r")
	if os_release then
		os_release:close()
		return true
	end

	return false
end

function IsMacOS()
	local is_darwin = (os.getenv("OSTYPE") or ""):match("darwin") or jit.os == "OSX"
	if is_darwin then
		return true
	end
	local file = io.open("/System/Library/CoreServices/SystemVersion.plist", "r")
	if file then
		file:close()
		return true
	end
	return false
end

function IsWindows()
	return package.config:sub(1, 1) == "\\" or os.getenv("OS") == "Windows_NT"
end

function isGNOME()
	if not IsArchLinux() then
		return false
	end

	local desktop_session = os.getenv("XDG_SESSION_DESKTOP")
	return desktop_session == "GNOME"
end

-- BASE --

config.front_end = "OpenGL"
config.max_fps = 144
config.term = "xterm-256color"

if IsWindows() then
	config.default_prog = { "pwsh", "-nologo" }
end

if IsArchLinux() or IsMacOS() then
	config.default_prog = { "zsh" }
end

if IsArchLinux() then
	config.enable_wayland = true
	config.term = "wezterm"
end

-- BASE --

-- CONSTANTS --

local WIN_OPACITY = 0.8
local FONT_SIZE = 13

if IsArchLinux() then
	FONT_SIZE = 12
end

-- CONSTANTS --

-- COLORS --

config.window_background_opacity = WIN_OPACITY
config.color_scheme = "Rosé Pine (Gogh)"
config.colors = {
	background = "rgba(25, 23, 36, 1)",
}

config.font = wezterm.font("FiraCode Nerd Font", { weight = "Bold" })
config.font_size = FONT_SIZE

-- COLORS --

-- WINDOW --

config.hide_tab_bar_if_only_one_tab = not isGNOME()
config.window_frame = {
	font = config.font,
	font_size = FONT_SIZE - 1,

	active_titlebar_bg = config.colors.background,
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.65,
}

config.window_decorations = "RESIZE"

-- WINDOW --

-- KEYS --

config.keys = {
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "o",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			local opacity = overrides.window_background_opacity
			if opacity == 1.0 then
				overrides.window_background_opacity = WIN_OPACITY
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- KEYS --

return config
