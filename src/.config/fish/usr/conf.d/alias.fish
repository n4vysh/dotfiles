set -l file (
  string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
)

set -l cmd eza
if command -q "$cmd"
    # NOTE: use eza in __fish_list_current_token function
    alias ls="$cmd -gF --icons --git --time-style long-iso"
else
    printf '%s: Not found %s command\n' "$file" "$cmd" >&2
end
