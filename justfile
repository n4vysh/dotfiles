link: prelink _stow postlink

prelink:
    mkdir -p ~/.config/ ~/.local/bin/ ~/.local/src/

_stow *opt:
    stow {{ opt }} -v -d src/ -t ~/ .

postlink:
    home-manager switch
    cp src/.config/git/{scripts/pre-commit.bash,templates/hooks/pre-commit}
    systemctl --user enable tmux

unlink: (_stow "-D")

dry-run-link: (_stow "-n")

dry-run-unlink: (_stow "-n" "-D")

install:
    cat misc/pkglist/* | yay -S --needed -

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
            {{ justfile_directory() }}/misc/firefox/chrome \
            ~/.mozilla/firefox/{}/chrome
    [[ -f ~/.mozilla/firefox/profiles.ini ]] && \
        crudini --get ~/.mozilla/firefox/profiles.ini Profile0 Path | \
        xargs -I {} ln -fsv \
            {{ justfile_directory() }}/misc/firefox/search.json.mozlz4 \
            ~/.mozilla/firefox/{}/search.json.mozlz4

install-tresorit:
    curl -o '/tmp/#1' 'https://installer.tresorit.com/{tresorit_installer.run}'
    chmod +x /tmp/tresorit_installer.run
    /tmp/tresorit_installer.run

configure-tresorit:
    ~/.local/share/tresorit/tresorit-cli sync --start Documents --path ~/Documents
    ~/.local/share/tresorit/tresorit-cli sync --start Music --path ~/Music
    ~/.local/share/tresorit/tresorit-cli sync --start Pictures --path ~/Pictures
    ~/.local/share/tresorit/tresorit-cli sync --start Videos --path ~/Videos

test *target:
    pre-commit run -av {{ target }}

test-in-container:
    test/scripts/dgoss.bash

build:
    docker build -t n4vysh/dotfiles --progress=plain .
