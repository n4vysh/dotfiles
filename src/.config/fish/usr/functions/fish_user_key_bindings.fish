function fish_user_key_bindings
    set -l fn __fish_paginate_extend
    if functions -q "$fn"
        bind --preset \cx\cp __fish_paginate_extend
        bind --preset -M insert \cx\cp __fish_paginate_extend
        bind --preset -M visual \cx\cp __fish_paginate_extend
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    set -l fn __fish_man_page
    if functions -q "$fn"
        bind --preset \cx\ch __fish_man_page
        bind --preset -M insert \cx\ch __fish_man_page
        bind --preset -M visual \cx\ch __fish_man_page
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    set -l fn edit_command_buffer
    if functions -q "$fn"
        bind --preset \cx\ce edit_command_buffer
        bind --preset -M insert \cx\ce edit_command_buffer
        bind --preset -M visual \cx\ce edit_command_buffer
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    set -l fn __fish_list_current_token
    if functions -q "$fn"
        bind --preset \cx\cl __fish_list_current_token
        bind --preset -M insert \cx\cl __fish_list_current_token
        bind --preset -M visual \cx\cl __fish_list_current_token
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    set -l fn __fish_preview_current_file
    if functions -q "$fn"
        bind --preset \cx\co __fish_preview_current_file
        bind --preset -M insert \cx\co __fish_preview_current_file
        bind --preset -M visual \cx\co __fish_preview_current_file
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    set -l fn __fish_whatis_current_token
    if functions -q "$fn"
        bind --preset \cx\cw __fish_whatis_current_token
        bind --preset -M insert \cx\cw __fish_whatis_current_token
        bind --preset -M visual \cx\cw __fish_whatis_current_token
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    bind --preset \cx\cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
    bind --preset -M insert \cx\cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
    bind --preset -M visual \cx\cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'

    fish_user_execute_key_bindings \cob bluetuith
    fish_user_execute_key_bindings \coc lazydocker
    fish_user_execute_key_bindings \co\cc k9s
    fish_user_execute_key_bindings \cod nvim -c DBUI
    fish_user_execute_key_bindings \coe nvim
    fish_user_execute_key_bindings \cof n
    fish_user_execute_key_bindings \com btm
    fish_user_execute_key_bindings \co\cm ncspot
    fish_user_execute_key_bindings \co\cp sudo informant read
    fish_user_execute_key_bindings \cos bash -l
    fish_user_execute_key_bindings \cot unbuffer tree \| less
    fish_user_execute_key_bindings \co\ct rlwrap -a trans -b
    fish_user_execute_key_bindings \cov lazygit
    fish_user_execute_key_bindings \co\cv gh dash
    fish_user_execute_key_bindings \coz zi
    fish_user_execute_key_bindings \cz fg
end
