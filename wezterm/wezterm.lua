---@diagnostic disable:undefined-global

-- Initialize
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local opacity = 0.75

--- Color Scheme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono Nerd Font",
		weight = "Regular",
	},
	"Segoe UI Emoji",
})
config.font_size = 11

-- Window
config.initial_rows = 45
config.initial_cols = 180
config.window_decorations = "RESIZE"
config.window_background_opacity = opacity
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

-- Shell
config.default_prog = { "pwsh", "-NoLogo" }

-- Tabs
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Keybindings
config.keys = {
	-- Remap paste for clipboard history compatibility
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

--- Tmux
config.leader = { key = "f", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
}

-- leader + 0-9 to switch tabs
for i = 1, 9 do
	table.insert(config.keys, {
		mods = "LEADER",
		key = tostring(i),
		action = wezterm.action.ActivateTab(i - 1), -- indexed tabs start from 0
	})
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local prefix = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#181825" } } -- Catppuccin Mocha Mantle

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f47e) -- space invader
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	-- arrow color based on if tab is first pane
	wezterm.log_info("tab id: " .. tostring(window:active_tab():tab_id()))
	if window:active_tab():tab_id() == 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#cba6f7" } } -- Catppuccin Mocha Mauve
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b4befe" } }, -- Catppuccin Mocha Lavender
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- Finish
return config
