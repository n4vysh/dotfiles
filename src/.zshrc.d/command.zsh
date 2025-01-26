eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

# direnv
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
emulate zsh -c "$(direnv hook zsh)"
