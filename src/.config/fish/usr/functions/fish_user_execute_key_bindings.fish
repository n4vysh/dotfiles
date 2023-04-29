function fish_user_execute_key_bindings
    if test (count $argv) -eq 0
        printf '%s: Missing sequence and commands\n' "$file" >&2
        return 1
    end

    if test (count $argv) -eq 1
        printf '%s: Missing commands\n' "$file" >&2
        return 1
    end

    set -l seq "$argv[1]"
    set -l cmd "$argv[2]"
    set -l cmds "$argv[2..-1]"

    if test "$cmd" -eq sudo
        or test "$cmd" -eq unbuffer
        cmd = "$argv[3]"
    end

    if type -q "$cmd"
        bind -M insert "$seq" "commandline -r '$cmds'; commandline -f execute"
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
        return 1
    end
end
