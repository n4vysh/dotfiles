eval "$(zoxide init zsh)"
eval "$(command wt config shell init zsh)"

# NOTE: suppress output after instant prompt
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[mise]} )) && emulate zsh -c "$(mise activate --quiet zsh)"

source /usr/share/doc/pkgfile/command-not-found.zsh
