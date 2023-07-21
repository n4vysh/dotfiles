[[ $- != *i* ]] && return
PS1='\$ '
shopt -s cmdhist
shopt -s lithist
eval "$(rtx activate bash)"
