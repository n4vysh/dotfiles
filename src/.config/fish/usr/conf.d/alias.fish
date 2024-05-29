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

# NOTE: use command completion and grc command
set -l cmds \
    docker df dig du env free go id kubectl last lsblk lsof \
    nmap ping ps traceroute uptime whois
for cmd in $cmds
    if command -q "$cmd"
        alias "$cmd"="grc $cmd"
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
    end
end

set -l cmd elia
if command -q "$cmd"
    alias "$cmd"=elia-wrapper
else
    printf '%s: Not found %s command\n' "$file" "$cmd" >&2
end
