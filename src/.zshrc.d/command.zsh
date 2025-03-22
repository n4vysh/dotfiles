eval "$(zoxide init zsh)"

# NOTE: suppress trusted status with --quiet option after instant prompt
# https://github.com/romkatv/powerlevel10k/tree/master?tab=readme-ov-file#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[mise]} )) && emulate zsh -c "$(mise activate --quiet zsh)"
