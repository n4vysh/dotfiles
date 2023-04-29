function __fish_abbr_add_extend --description \
    "Add fish global abbreviation with checking command existent"
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status function)
    )

    if test (count $argv) -eq 0
        printf '%s: Missing word and expansion\n' "$file" >&2
        return 1
    end

    if test (count $argv) -eq 1
        printf '%s: Missing expansion\n' "$file" >&2
        return 1
    end

    set -l cmd "$argv[2]"

    set -l word "$argv[1]"
    set -l expansion $argv[2..-1]

    if type -q "$cmd"
        abbr --add --global -- "$word" "$expansion"
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
        return 1
    end
end
