link: prelink _stow postlink

prelink:
    mkdir -p ~/.config/ ~/.local/bin/ ~/.local/src/

_stow *opt:
    stow {{ opt }} -v -d src/ -t ~/ .

postlink:
    cp src/.config/git/{scripts/pre-commit.bash,templates/hooks/pre-commit}
    systemctl --user enable tmux

unlink: (_stow "-D")

dry-run-link: (_stow "-n")

dry-run-unlink: (_stow "-n" "-D")

install:
    cat misc/pkglist/* | paru -S --needed -

install-git-hooks:
    pre-commit install --install-hooks
    pre-commit install --hook-type commit-msg

configure-firefox:
    [[ -f ~/.mozilla/firefox/profiles.ini ]] && \
        crudini --get ~/.mozilla/firefox/profiles.ini Profile0 Path | \
        xargs -I {} ln -fsv \
            {{ justfile_directory() }}/misc/firefox/user.js \
            ~/.mozilla/firefox/{}/user.js
    [[ -f ~/.mozilla/firefox/profiles.ini ]] && \
        crudini --get ~/.mozilla/firefox/profiles.ini Profile0 Path | \
        xargs -I {} ln -fsv \
            {{ justfile_directory() }}/misc/firefox/search.json.mozlz4 \
            ~/.mozilla/firefox/{}/search.json.mozlz4

test *target:
    pre-commit run -av {{ target }}

test-in-container:
    test/scripts/dgoss.bash

build:
    docker build -t n4vysh/dotfiles --progress=plain .
