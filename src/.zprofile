# NOTE: Use tty2 for ly
if [[ -z $DISPLAY ]] && [[ $XDG_VTNR = 2 ]]; then
	export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS='@im=fcitx'

	# for firefox and thunderbird
	export MOZ_ENABLE_WAYLAND=1

	# https://www.reddit.com/r/voidlinux/comments/mor7n5/getting_libseat_errors_when_starting_sway/
	export LIBSEAT_BACKEND=logind

	# https://github.com/swaywm/sway/issues/1000
	mkdir -p "$XDG_CACHE_HOME/sway/"
	exec sway >"$XDG_CACHE_HOME/sway/log.txt" 2>&1
fi

if [[ -f ~/.zprofile.local ]]; then
	source ~/.zprofile.local
fi

exec fish
