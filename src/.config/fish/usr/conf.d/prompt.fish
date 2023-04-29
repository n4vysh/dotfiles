set -l file (
  string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
)

set -l cmd starship
if command -q "$cmd"
    "$cmd" init fish |
        source
else
    printf '%s: Not found starship command\n' "$file" "$cmd" >&2
end
