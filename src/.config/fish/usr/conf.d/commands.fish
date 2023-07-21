if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if command -q rtx
        if not functions -q rtx
            rtx activate fish |
                source
        end

        set -l lib $XDG_CONFIG_HOME/direnv/lib/use_rtx.sh
        if not test -e "$lib"
            rtx direnv activate >$lib
        end
    else
        printf '%s: Not found rtx command\n' "$file" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if command -q zoxide
        if not functions -q z
            zoxide init fish |
                source
        end
    else
        printf '%s: Not found zoxide command\n' "$file" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if command -q s
        set -l completion $XDG_CONFIG_HOME/fish/completions/s.fish
        if not test -e "$completion"
            s --completion fish >$XDG_CONFIG_HOME/fish/completions/s.fish
        end
    else
        printf '%s: Not found s command\n' "$file" >&2
    end
end
