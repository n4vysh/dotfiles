[[ $- != *i* ]] && return
PS1='\$ '
shopt -s cmdhist
shopt -s lithist
eval "$(mise activate bash)"
eval "$(direnv hook bash)"
