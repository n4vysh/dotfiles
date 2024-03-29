local wezterm = require("wezterm")

wezterm.on("format-window-title", function()
	return "WezTerm"
end)

return {
	font = wezterm.font_with_fallback({
		"Fira Code",
		"Symbols NFM",
		"Noto Sans JP",
	}),
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	color_scheme = "tokyonight",
	enable_tab_bar = false,
	window_background_opacity = 0.9,
	default_prog = { "/Windows/System32/wsl.exe", "~", "-d", "Arch", "tmuxs" },
	canonicalize_pasted_newlines = "LineFeed",
	adjust_window_size_when_changing_font_size = false,
	allow_win32_input_mode = false,
	check_for_updates = false,
	window_close_confirmation = "NeverPrompt",
}
