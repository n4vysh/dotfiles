if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if command -q mise
        set -l completion $XDG_CONFIG_HOME/fish/completions/mise.fish
        if not test -e "$completion"
            mise completion fish >$XDG_CONFIG_HOME/fish/completions/mise.fish
        end

        if not functions -q mise
            mise activate fish |
                source
        end

        mkdir -p $XDG_CONFIG_HOME/direnv/lib/
        set -l lib $XDG_CONFIG_HOME/direnv/lib/use_mise.sh
        if not test -e "$lib"
            mise direnv activate >$lib
        end
    else
        printf '%s: Not found mise command\n' "$file" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if command -q direnv
        # NOTE: setup shell hook after mise activate to correct PATH order
        direnv hook fish |
            source
    else
        printf '%s: Not found direnv command\n' "$file" >&2
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
