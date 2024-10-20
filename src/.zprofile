if [[ -f ~/.zprofile.local ]]; then
	source ~/.zprofile.local
fi

if [[ -z $DISPLAY ]] && [[ $XDG_VTNR = 2 ]]; then
	# NOTE: Do not start shell to use tty2 for ly
	:
else
	exec fish
fi
