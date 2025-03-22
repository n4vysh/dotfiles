if [[ -z $TMUX ]]; then
	if tmux has-session 2>/dev/null; then
		tmux attach-session -d
	else
		tmux new-session
	fi
fi

echo -e '\e[5 q' # beam cursor

# NOTE: output trusted status of mise before instant prompt
# https://github.com/romkatv/powerlevel10k/tree/master?tab=readme-ov-file#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[mise]} )) && emulate zsh -c "$(mise hook-env -s zsh)"

# powerlevel10k instant prompt
# NOTE: console I/O must go above this block
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# initialize sheldon
eval "$(sheldon source)"

# powerlevel10k options
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
