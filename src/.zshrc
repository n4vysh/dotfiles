if [[ -z $TMUX ]]; then
	if tmux has-session 2>/dev/null; then
		tmux attach-session -d
	else
		tmux new-session
	fi
fi

echo -e '\e[5 q' # beam cursor

# powerlevel10k instant prompt
# NOTE: console I/O must go above this block
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# initialize sheldon
eval "$(sheldon source)"

# powerlevel10k options
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
