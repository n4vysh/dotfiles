#!/bin/sh

gum log --level info 'Configure window manager'
hyprpm update --no-shallow
yes | hyprpm add https://github.com/outfoxxed/hy3
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hy3
hyprpm enable hyprbars

gum log --level info 'Create user directories'
mkdir -p "$HOME/Downloads" "$HOME/Public" "$HOME/Workspaces"

gum log --level info 'Configure wallpaper'
if ! [ -f "${XDG_DATA_HOME}/hypr/wallpaper.jpeg" ]; then
	mkdir -p "${XDG_DATA_HOME}/hypr/"
	# https://www.pexels.com/photo/buildings-with-blue-light-747101/
	curl \
		'https://images.pexels.com/photos/747101/pexels-photo-747101.jpeg?dl&fit=crop&crop=entropy&w=1920&h=1280' \
		>"${XDG_DATA_HOME}/hypr/wallpaper.jpeg"
else
	gum log --level warn 'wallpaper already exists -- skipping'
fi
