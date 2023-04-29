[[ $- != *i* ]] && return
PS1='\$ '
shopt -s cmdhist
shopt -s lithist
if ! type asdf >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  source /opt/asdf-vm/asdf.sh
fi
if [[ ! -e "$ASDF_DIRENV_BIN" ]]; then
  asdf plugin-add direnv
fi
if [[ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/bashrc" ]]; then
  asdf direnv setup --shell bash --version latest
fi
# shellcheck source=/dev/null
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/bashrc"
