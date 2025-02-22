if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l cmd mise
    if command -q "$cmd"
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
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l cmd direnv
    if command -q "$cmd"
        # NOTE: setup shell hook after mise activate to correct PATH order
        direnv hook fish |
            source
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l cmd zoxide
    if command -q "$cmd"
        if not functions -q z
            zoxide init fish |
                source
        end
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l cmd aws_completer
    if command -q "$cmd"
        complete -c aws -f -a '(
            begin
                set -lx COMP_SHELL fish
                set -lx COMP_LINE (commandline)
                aws_completer
            end
        )'
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
    end
end
