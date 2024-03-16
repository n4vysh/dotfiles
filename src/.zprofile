# NOTE: Use tty2 for ly
if [[ -z $DISPLAY ]] && [[ $XDG_VTNR = 2 ]]; then
	export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS='@im=fcitx'

	# for firefox
	export MOZ_ENABLE_WAYLAND=1

	# https://www.reddit.com/r/voidlinux/comments/mor7n5/getting_libseat_errors_when_starting_sway/
	export LIBSEAT_BACKEND=logind

	# HACK: ignore fcitx5 diagnose notification
	# https://github.com/fcitx/fcitx5/blob/ebe3f3176331229c42850d61bbc5c78aaadddf8d/src/modules/wayland/waylandmodule.cpp#L502-L504
	# https://github.com/swaywm/sway/wiki#xdg_current_desktop-environment-variable-is-not-being-set
	export XDG_CURRENT_DESKTOP=sway

	# https://github.com/swaywm/sway/issues/1000
	mkdir -p "$XDG_CACHE_HOME/sway/"
	exec sway >"$XDG_CACHE_HOME/sway/log.txt" 2>&1
fi

if [[ -f ~/.zprofile.local ]]; then
	source ~/.zprofile.local
fi

exec fish
