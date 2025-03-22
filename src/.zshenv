# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=~/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=~/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:=~/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:=~/.local/state}

# base
export PAGER=less
export EDITOR=nvim
export BROWSER=firefox
export DIFFPROG='nvim -d'
export DO_NOT_TRACK=1
export QT_STYLE_OVERRIDE=Adwaita-Dark
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
if type vivid >/dev/null 2>&1; then
	export LS_COLORS="$(vivid generate tokyonight-night)"
fi
if [[ -n $DISPLAY ]]; then
	eval $(gnome-keyring-daemon --start 2>/dev/null)
	export SSH_AUTH_SOCK
fi
if type tty gpg-connect-agent >/dev/null 2>&1; then
	export GPG_TTY=$TTY
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi

# zsh
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export WORDCHARS="${WORDCHARS/\//}"
zle_highlight=('paste:none')

fpath=(~/.zfunctions $fpath)
autoload -Uz ~/.zfunctions/*(.:t)

## color
local foreground='#c0caf5'
local selection='#283457'
local comment='#565f89'
local red='#f7768e'
local orange='#ff9e64'
local yellow='#e0af68'
local green='#9ece6a'
local purple='#9d7cd8'
local cyan='#7dcfff'
local pink='#bb9af7'

### syntax
typeset -gA FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[default]="fg=${foreground}"
FAST_HIGHLIGHT_STYLES[command]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[builtin]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[alias]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[function]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[command-substitution]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[process-substitution]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[process-substitution-delimiter]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[back-quoted-argument]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[redirection]="fg=${foreground}"
FAST_HIGHLIGHT_STYLES[comment]="fg=${comment}"
FAST_HIGHLIGHT_STYLES[variable]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[brackets]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[bracket-level-1]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[bracket-level-2]="fg=${green}"
FAST_HIGHLIGHT_STYLES[bracket-level-3]="fg=${yellow}"
FAST_HIGHLIGHT_STYLES[glob]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[history-expansion]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[commandseparator]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[unknown-token]="fg=${red}"
FAST_HIGHLIGHT_STYLES[reserved-word]="fg=${pink}"
FAST_HIGHLIGHT_STYLES[precommand]="fg=${green}"
FAST_HIGHLIGHT_STYLES[paths]="fg=${foreground}"
FAST_HIGHLIGHT_STYLES[paired-bracket]="bg=${selection}"
FAST_HIGHLIGHT_STYLES[assign]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[assign-array-bracket]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[directory-pointer]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[path-to-dir]="fg=${cyan},underline"
FAST_HIGHLIGHT_STYLES[path]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[mathvar]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[mathnum]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[matherr]="fg=${red}"
FAST_HIGHLIGHT_STYLES[assign-array-bracket]="fg=${cyan}"
FAST_HIGHLIGHT_STYLES[for-loop-variable]="fg=${purple}"
FAST_HIGHLIGHT_STYLES[for-loop-number]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[for-loop-operator]="fg=${orange}"
FAST_HIGHLIGHT_STYLES[for-loop-separator]="fg=${orange}"

### completion
zstyle ':completion:*' format "%F{${cyan}}%B❯ %d%b%f"
zstyle ':completion:*:descriptions' format "%F{${comment}}%d%f"
zstyle ':completion:*:messages' format "%F{${cyan}}%d%f"
zstyle ':completion:*:corrections' format "%F{${yellow}}%B❯ %d (typo: %e)%b%f"
zstyle ':completion:*:descriptions' format "%F{${yellow}}%B❯ %d%b%f"
zstyle ':completion:*:messages' format "%F{${purple}}%B❯ %d%b%f"
zstyle ':completion:*:warnings' format "%F{${red}}%B no matches found%b%f"

# path
typeset -U path PATH
path=($HOME/.local/bin(N-/) $path)
path=($HOME/.nix-profile/bin(N-/) $path)
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
	--info=inline-right
	--color hl:27,bg+:21,hl+:75
	--color info:69,prompt:75,spinner:69,pointer:69,marker:69,scrollbar:75
"
export FZF_CTRL_R_OPTS="
	--preview 'echo {2..} | bat --color=always -pl zsh'
	--preview-window 'wrap,down,5'
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

# Terraform
export TF_CLI_ARGS_plan="-parallelism=30"
export TF_CLI_ARGS_apply="-parallelism=30"

# aws
export AWS_CLI_AUTO_PROMPT=on-partial

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

# kubectx
# NOTE: set kubeconfig per shell session
# https://github.com/ahmetb/kubectx/issues/12#issuecomment-557852519
if [[ -f ~/.kube/config ]]; then
	file="$(mktemp -t "kubectx.XXXXXX")"
	cat ~/.kube/config >|"$file"
	export KUBECONFIG="$file"
fi

# timg
export TIMG_PIXELATION=kitty

# local
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
