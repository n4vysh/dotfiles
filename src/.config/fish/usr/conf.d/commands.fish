if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l function /opt/asdf-vm/asdf.fish
    if not test -e "$function"
        printf '%s: Not found %s\n' "$file" "$function" >&2
    else if not test -f "$function"
        printf '%s: Not regular file %s\n' "$file" "$function" >&2
    else if not test -r "$function"
        printf '%s: Not readable %s\n' "$file" "$function" >&2
    else if test -f "$function"; and test -r "$function"
        if not functions -q asdf
            source "$function"
        end
    end

    if not test -e "$ASDF_DIRENV_BIN"
        printf '%s: Add direnv plugin of asdf\n' "$file"
        asdf plugin-add direnv
    end

    set -l conf "$XDG_CONFIG_HOME/fish/conf.d/asdf_direnv.fish"
    if not test -e "$conf"
        printf '%s: execute setup command of asdf-direnv\n' "$file"
        asdf direnv setup --shell fish --version latest
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
