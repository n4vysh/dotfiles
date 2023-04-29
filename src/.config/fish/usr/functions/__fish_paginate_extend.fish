function __fish_paginate_extend \
    --wraps=__fish_paginate \
    --description \
    'Paginate the current command using the users default pager and unbuffer command'
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status function)
    )

    set -l cmd unbuffer
    if command -q "$cmd"
        __fish_paginate
        fish_commandline_prepend "$cmd"
    else
        printf '%s: Not found %s command\n' "$file" "$cmd" >&2
        return 1
    end
end
