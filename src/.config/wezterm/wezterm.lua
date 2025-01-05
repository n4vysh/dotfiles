local wezterm = require("wezterm")

wezterm.on("format-window-title", function()
	return "WezTerm"
end)

return {
	default_prog = { "tmuxs" },
	color_scheme = "tokyonight",
	font = wezterm.font_with_fallback({
		"Fira Code",
		"Symbols Nerd Font Mono",
		"Noto Sans Mono CJK JP",
		"Noto Sans Symbols",
		"Noto Sans Math",
	}),
	font_size = 13.0,
	enable_tab_bar = false,
	window_background_opacity = 0.8,
	use_ime = true,
	enable_wayland = true,
	check_for_updates = false,
	window_close_confirmation = "NeverPrompt",
}
