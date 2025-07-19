autoload -Uz compinit && compinit

compdef _gnu_generic fzf
compdef kubecolor=kubectl
source /usr/bin/aws_zsh_completer.sh

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' completer _complete _match _prefix _approximate _list
zstyle ':completion:*' list-separator '  '
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion::complete:*' gain-privileges 1

# grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:manuals' separate-sections true

# NOTE: skip list-prompt and hide hints
bindkey "^I" menu-complete
zstyle ':completion:*' list-prompt '%S%p %m%s'
zstyle ':completion:*' select-prompt '%S%p %m%s'

# NOTE: use one-dark instead of tokyonight
#       tokyonight is not work when some directory
zstyle ':completion:*' list-colors "$(vivid generate one-dark)"
