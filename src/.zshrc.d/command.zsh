eval "$(zoxide init zsh)"

# NOTE: suppress output after instant prompt
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[mise]} )) && emulate zsh -c "$(mise activate --quiet zsh)"
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
