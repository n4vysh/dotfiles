# XDG
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

# base
export PAGER=less
export EDITOR=nvim
export BROWSER=firefox
export DIFFPROG='nvim -d'
export DO_NOT_TRACK=1
export QT_STYLE_OVERRIDE=Adwaita-Dark
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
if type vivid >/dev/null 2>&1; then
	export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi
if [[ -n $DISPLAY ]]; then
	eval $(gnome-keyring-daemon --start 2>/dev/null)
	export SSH_AUTH_SOCK
fi
if type tty gpg-connect-agent >/dev/null 2>&1; then
	export GPG_TTY=$(tty)
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi

# tmux
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"

# path
typeset -U path PATH
path=($HOME/.local/bin(N-/) $path)
path=($path $PNPM_HOME(N-/))
path=($path $HOME/.krew/bin(N-/))

# Programming
export GOPATH="$HOME/.local"
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Less
export LESS='-ciMR'
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;38;05;75m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;36m'
export LESS_CACHE_HOME="$XDG_CACHE_HOME/less"
export LESSHISTFILE="$LESS_CACHE_HOME/history"

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_DEFAULT_OPTS="
	--ansi
	--exit-0
	--extended
	--cycle
	--multi
	--height 40%
	--reverse
	--prompt='▶ '
	--color hl:27,bg+:21,hl+:75
	--color info:69,prompt:75,spinner:69,pointer:69,marker:69
	--bind ctrl-j:jump-accept
"

# nnn
export LC_COLLATE=C
export NNN_OPTS=aAcdeUx
export NNN_NO_AUTOSELECT=1
export NNN_TRASH=1
export NNN_PLUG=$(
	cat <<-'EOS' | tr -d '\n'
		d:!nnn-diff*;
		e:-!$EDITOR*;
		f:-!$PAGER $nnn*;
		h:!nnn-home*;
		l:!lazygit --filter $PWD/$nnn*;
		n:bulknew;
		p:preview-tui;
		r:gitroot;
		s:!$SHELL -l*;
		t:!trash-restore*;
		u:-!dust -rP | less*;
		v:!lazygit*;
		y:!echo -n "$nnn" | wl-copy*;
		z:autojump
	EOS
)
export GUI=1
export NNN_OPENER=nuke
export NNN_ARCHIVE=$(
	cat <<-'EOS' | tr -d '\n'
		\.(
			7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|
			rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip
		)$
	EOS
)

# bemenu
export BEMENU_OPTS="
	--tb '#0018a8'
	--tf '#f5f5f5'
	--hb '#0018a8'
	--hf '#f5f5f5'
	--fn 'NotoSansMonoCJKJP 13.5'
"

# Terraform
export TF_CLI_ARGS_plan="-parallelism=30"
export TF_CLI_ARGS_apply="-parallelism=30"

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_CMD=gopass
export AWS_VAULT_PASS_PREFIX=aws-vault

# john
# https://github.com/open-mpi/hwloc/issues/354
export HWLOC_HIDE_ERRORS=2
# https://github.com/openwall/john/issues/4765
export OMPI_MCA_opal_warn_on_missing_libcuda=0

# Nix
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# GUI
if [[ -z $DISPLAY ]] && [[ $XDG_VTNR = 2 ]]; then
	export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS='@im=fcitx'

	# for firefox
	export MOZ_ENABLE_WAYLAND=1

	# for java applications
	export _JAVA_AWT_WM_NONREPARENTING=1

	# HACK: ignore fcitx5 diagnose notification
	# https://github.com/fcitx/fcitx5/blob/ebe3f3176331229c42850d61bbc5c78aaadddf8d/src/modules/wayland/waylandmodule.cpp#L502-L504
	# https://github.com/swaywm/sway/wiki#xdg_current_desktop-environment-variable-is-not-being-set
	export XDG_CURRENT_DESKTOP=sway
fi

# local
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
