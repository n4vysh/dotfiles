function fish_user_key_bindings
    set -l fn __fish_paginate_extend
    if functions -q "$fn"
        bind --preset \ep __fish_paginate_extend
        bind --preset -M insert \ep __fish_paginate_extend
        bind --preset -M visual \ep __fish_paginate_extend
    else
        printf '%s: Not found %s function\n' "$file" "$fn" >&2
        return 1
    end

    fish_user_execute_key_bindings \cob bluetuith
    fish_user_execute_key_bindings \coc lazydocker
    fish_user_execute_key_bindings \co\cc k9s
    fish_user_execute_key_bindings \cod nvim -c DBUI
    fish_user_execute_key_bindings \coe nvim
    fish_user_execute_key_bindings \cof n
    fish_user_execute_key_bindings \com btm
    fish_user_execute_key_bindings \co\cm ncspot
    fish_user_execute_key_bindings \con $EDITOR \~/Documents/note.md
    fish_user_execute_key_bindings \co\cp sudo informant read
    fish_user_execute_key_bindings \cos bash -l
    fish_user_execute_key_bindings \cot $EDITOR \~/Documents/tasks.md
    fish_user_execute_key_bindings \cov lazygit
    fish_user_execute_key_bindings \co\cv gh dash
    fish_user_execute_key_bindings \coz zi
    fish_user_execute_key_bindings \cz fg

    fish_user_execute_key_bindings \cxt unbuffer tree \| less
    fish_user_execute_key_bindings \cx\ch cd \~
    fish_user_execute_key_bindings \cx\cp cd \-
    fish_user_execute_key_bindings \cx\cr cd '$(git rev-parse --show-toplevel)'

    bind -M insert \cxa "commandline -i ' && '"
    bind -M insert \cxo "commandline -i ' || '"
end
