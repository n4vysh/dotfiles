echo -e '\e[5 q' # beam cursor

# direnv
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
emulate zsh -c "$(direnv export zsh)"

# powerlevel10k instant prompt
# NOTE: console I/O must go above this block
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# initialize sheldon
eval "$(sheldon source)"

# powerlevel10k options
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
