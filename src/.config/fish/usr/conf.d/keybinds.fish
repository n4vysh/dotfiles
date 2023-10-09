set -g fish_key_bindings fish_hybrid_key_bindings

set -l file (
  string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
)

set -l cmd fzf
if command -q "$cmd"
    fzf_configure_bindings \
        --directory=\cx\cf \
        --git_log= \
        --git_status= \
        --processes= \
        --variables=\cq
else
    printf '%s: Not found %s command\n' "$file" "$cmd" >&2
end
